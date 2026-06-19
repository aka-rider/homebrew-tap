class WhisperCppSileroVad < Formula
  desc "Silero VAD GGML model for whisper-cpp"
  homepage "https://huggingface.co/ggml-org/whisper-vad"
  url "https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v6.2.0.bin"
  version "6.2.0"
  sha256 "2aa269b785eeb53a82983a20501ddf7c1d9c48e33ab63a41391ac6c9f7fb6987"
  license "MIT"

  def install
    (pkgshare/"models").install "ggml-silero-v6.2.0.bin"
  end

  test do
    assert_path_exists pkgshare/"models/ggml-silero-v6.2.0.bin"
  end
end
