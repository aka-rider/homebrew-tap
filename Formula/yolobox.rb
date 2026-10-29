class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.7.2/yolobox-1.7.2.tar.gz"
  sha256 "3a685bc2649543835fe838110406f1268d5bfa2893fbe136bbe13d7112d9a900"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64
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
