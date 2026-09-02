class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v0.9.1/yolobox-0.9.1.tar.gz"
  sha256 "0b410804c71db9ff413eab737c032b72face4ead54803caa8dac05eda6e57ccc"
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
