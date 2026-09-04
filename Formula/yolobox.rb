class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.0.0/yolobox-1.0.0.tar.gz"
  sha256 "9d88284c3f37c5461ee9c6178a03ef5654ab98e5fa4b5c9a86265b8efe5da42b"
  license "MIT"

  depends_on "fzf"
  depends_on "lima"

  def install
    libexec.install "yo", "aws-broker"
    (libexec/"lima").install "lima/yolobox.yaml"
    inreplace libexec/"yo", 'YO_VERSION = "dev"', "YO_VERSION = \"#{version}\""
    bin.install_symlink libexec/"yo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
  end
end
