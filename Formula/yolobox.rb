class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.3.3/yolobox-1.3.3.tar.gz"
  sha256 "0d89aacaf5ab0aa951b22f52a10e7a6be86a6b2b94aefd858e02fd80e7bf2ad8"
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
