class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.9.3/yolobox-1.9.3.tar.gz"
  sha256 "a41f2eaeba796c0d48fae18a0cf062c1bbd9e82dc7d2a51cccd481673f7a3c17"
  license "MIT"

  depends_on :macos
  depends_on "fzf"
  depends_on "lima"

  def install
    libexec.install "yo", "aws-broker"
    # macOS runs the Lima driver; the libvirt driver's modules and the Linux host
    # files stay out.
    (libexec/"yolobox_cli").install Dir["yolobox_cli/*.py"] - ["yolobox_cli/libvirt.py", "yolobox_cli/libvirt_host.py"]
    (libexec/"lima").install "lima/yolobox.yaml"
    inreplace libexec/"yolobox_cli/config.py", 'YO_VERSION = "dev"', "YO_VERSION = \"#{version}\""
    bin.install_symlink libexec/"yo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
  end
end
