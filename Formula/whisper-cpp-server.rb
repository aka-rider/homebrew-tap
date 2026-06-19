class WhisperCppServer < Formula
  desc "OpenAI Whisper HTTP server with VAD and Metal acceleration"
  homepage "https://github.com/ggml-org/whisper.cpp"
  # sha256 is populated after running release.yml — update before first install
  url "https://github.com/aka-rider/homebrew-tap/releases/download/v1.8.5/whisper-server-v1.8.5-arm64.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  # Pre-built for Apple Silicon only.
  depends_on "aka-rider/tap/whisper-cpp-large-v3-turbo"
  depends_on "aka-rider/tap/whisper-cpp-silero-vad"
  depends_on "libomp"

  on_intel do
    disable! date: "2026-06-18", because: "pre-built binary is Apple Silicon (arm64) only"
  end

  def install
    bin.install "whisper-server"

    vad_model = Formula["aka-rider/tap/whisper-cpp-silero-vad"].opt_pkgshare

    (etc/"whisper-cpp-server").mkpath
    config = etc/"whisper-cpp-server/config"
    config.write(default_config(vad_model)) unless config.exist?

    (bin/"whisper-cpp-service").write(service_wrapper)
    chmod 0755, bin/"whisper-cpp-service"
  end

  def default_config(vad_model)
    <<~CONF
      WHISPER_VAD_MODEL=#{vad_model}/models/ggml-silero-v6.2.0.bin
      WHISPER_HOST=127.0.0.1
      WHISPER_THREADS=6
      WHISPER_VAD_THRESHOLD=0.5
      WHISPER_VAD_MIN_SPEECH_MS=200
      WHISPER_VAD_MIN_SILENCE_MS=500
    CONF
  end

  def service_wrapper
    <<~SH
      #!/bin/sh
      . "#{etc}/whisper-cpp-server/config" 2>/dev/null || true
      "#{Formula["aka-rider/tap/whisper-cpp-large-v3-turbo"].opt_bin}/whisper-cpp-model-manager" || exit 1
      exec "#{opt_bin}/whisper-server" \\
        -m "#{var}/whisper-cpp-server/models/ggml-large-v3-turbo.bin" \\
        -t "${WHISPER_THREADS:-6}" -fa \\
        --vad \\
        --vad-model "${WHISPER_VAD_MODEL}" \\
        --vad-threshold "${WHISPER_VAD_THRESHOLD:-0.5}" \\
        --vad-min-speech-duration-ms "${WHISPER_VAD_MIN_SPEECH_MS:-200}" \\
        --vad-min-silence-duration-ms "${WHISPER_VAD_MIN_SILENCE_MS:-500}" \\
        --host "${WHISPER_HOST:-127.0.0.1}" \\
        "$@"
    SH
  end

  service do
    run opt_bin/"whisper-cpp-service"
    keep_alive true
    log_path var/"log/whisper-cpp-server.log"
    error_log_path var/"log/whisper-cpp-server.err.log"
  end

  def caveats
    <<~EOS
      Config (edit host, threads, VAD settings, then restart):
        #{etc}/whisper-cpp-server/config

      Start service:
        brew services start whisper-cpp-server

      First launch downloads ~3 GB and builds the CoreML encoder (~5-10 min).
      Subsequent launches are instant. See `brew info aka-rider/tap/whisper-cpp-large-v3-turbo`.

      Health check:
        curl http://127.0.0.1:8080/health

      Transcribe:
        curl -X POST http://127.0.0.1:8080/inference -F "file=@audio.wav"
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/whisper-server --help 2>&1")
  end
end
