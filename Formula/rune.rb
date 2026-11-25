class Rune < Formula
  desc "TUI markdown editor that protects your words"
  homepage "https://github.com/aka-rider/rune"
  version "1.5.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aka-rider/rune/releases/download/v1.5.3/rune-cli-aarch64-apple-darwin.tar.xz"
    sha256 "304dbb01a5f0b296be61c1b75957e2bbe0ac7c4025ddd522af1c42e3b8a21c67"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.3/rune-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4563442ce2d258c1dddbb1b82263f5b9dc6a5caad0143149ac9884587cbbf74e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.3/rune-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b08394b26a9a71a726900abc501e0565cf90712df14446456fc8488ee318f8c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rune"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rune"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rune"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
