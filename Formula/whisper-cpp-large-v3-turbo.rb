class WhisperCppLargeV3Turbo < Formula
  desc "Whisper large-v3-turbo model manager with ANE conversion (Apple Silicon)"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "cd702189cb5e608c8bc487f4b151db593c4455925b37cc06ef76b44861911db1"
  license "MIT"

  depends_on "uv"

  on_intel do
    disable! date: "2026-06-18", because: "ANE requires Apple Silicon"
  end

  def install
    (libexec/"scripts").install "models/convert-whisper-to-coreml.py"
    (bin/"whisper-cpp-model-manager").write model_manager
    chmod 0755, bin/"whisper-cpp-model-manager"
  end

  def model_manager
    <<~SH
      #!/bin/sh
      # First-run downloads:
      #   ~1.5 GB  ggml-large-v3-turbo.bin  (HuggingFace, for whisper-server)
      #   ~1.6 GB  large-v3-turbo.pt        (OpenAI CDN, fetched by openai-whisper during conversion)
      # Total first-run: ~3 GB. The .pt is cached at ~/.cache/whisper/ and can be deleted after.
      MODEL_DIR="#{var}/whisper-cpp-server/models"
      ANE_MODEL="$MODEL_DIR/ggml-large-v3-turbo-encoder.mlmodelc"
      GGML_MODEL="$MODEL_DIR/ggml-large-v3-turbo.bin"

      mkdir -p "$MODEL_DIR"

      # Fast path: ANE model already built
      [ -d "$ANE_MODEL" ] && exit 0

      # Download GGML model if missing (needed by whisper-server regardless of ANE)
      if [ ! -f "$GGML_MODEL" ]; then
        echo "whisper-cpp: downloading Whisper large-v3-turbo (~1.5 GB)..." >&2
        curl -fL --progress-bar \
          "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin" \
          -o "$GGML_MODEL.tmp" \
        && mv "$GGML_MODEL.tmp" "$GGML_MODEL" \
        || { rm -f "$GGML_MODEL.tmp"; echo "whisper-cpp: .bin download failed" >&2; exit 1; }
      fi

      # Convert to ANE-optimized CoreML (first run only, ~5-10 min).
      # openai-whisper internally downloads large-v3-turbo.pt (~1.6 GB) from OpenAI CDN.
      # Note: --optimize-ane help text says "currently broken" but the code fix is present
      # (commit ba5bcde8 added the missing squeeze/transpose). The flag IS functional.
      echo "whisper-cpp: building ANE CoreML encoder (first run ~5-10 min + ~1.6 GB Python download)..." >&2

      # The conversion script writes to models/coreml-encoder-<model>.mlpackage relative to CWD.
      # We cd one level above MODEL_DIR so that "models/" prefix resolves to MODEL_DIR itself.
      cd "$(dirname "$MODEL_DIR")"
      "#{formula_opt_bin("uv")}/uv" run --isolated \
        --with 'coremltools==7.2' \
        --with 'ane-transformers' \
        --with 'openai-whisper' \
        --with 'torch' \
        --with 'numpy<2' \
        "#{opt_libexec}/scripts/convert-whisper-to-coreml.py" \
        --model large-v3-turbo --encoder-only True --optimize-ane True \
      || {
        echo "whisper-cpp: ANE conversion failed — starting with CPU-only GGML model" >&2
        rm -rf "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlpackage"
        exit 0
      }

      # Compile .mlpackage → .mlmodelc
      /usr/bin/xcrun coremlc compile \
        "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlpackage" \
        "$MODEL_DIR/" \
      && rm -rf "$ANE_MODEL" \
      && mv "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlmodelc" "$ANE_MODEL" \
      && rm -rf "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlpackage" \
      || {
        echo "whisper-cpp: CoreML compile failed — starting with CPU-only GGML model" >&2
        rm -rf "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlpackage" \
               "$MODEL_DIR/coreml-encoder-large-v3-turbo.mlmodelc"
        exit 0
      }

      echo "whisper-cpp: ANE model ready. To free ~1.6 GB: rm ~/.cache/whisper/large-v3-turbo.pt" >&2
    SH
  end

  def caveats
    <<~EOS
      First launch downloads ~3 GB and builds the CoreML encoder (~5-10 min):
        ~1.5 GB  ggml-large-v3-turbo.bin   (HuggingFace)
        ~1.6 GB  large-v3-turbo.pt          (OpenAI CDN, cached at ~/.cache/whisper/)

      After first launch completes, subsequent launches are instant.
      The .pt file (~1.6 GB) is no longer needed after conversion:
        rm ~/.cache/whisper/large-v3-turbo.pt
    EOS
  end

  test do
    assert_predicate bin/"whisper-cpp-model-manager", :executable?
    assert_path_exists libexec/"scripts/convert-whisper-to-coreml.py"
  end
end
