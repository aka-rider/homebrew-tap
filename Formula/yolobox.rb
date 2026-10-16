class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.3.2/yolobox-1.3.2.tar.gz"
  sha256 "164d75cf8f7d4025d1dc55beb829273178c496e7e51bbede520037a6ae2b9307"
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
