class Yolobox < Formula
  desc "NixOS VM devbox for AI agents, run by Lima on a Mac"
  homepage "https://github.com/aka-rider/yolobox"
  url "https://github.com/aka-rider/yolobox/releases/download/v1.9.0/yolobox-1.9.0.tar.gz"
  sha256 "9b4cdd843d1d17da3510552dcb821c7c73e22d2fccefc3a94f2ef03af3d73a8e"
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
