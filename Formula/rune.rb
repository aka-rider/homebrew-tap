class Rune < Formula
  desc "TUI markdown editor that protects your words"
  homepage "https://github.com/aka-rider/rune"
  version "1.5.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aka-rider/rune/releases/download/v1.5.1/rune-cli-aarch64-apple-darwin.tar.xz"
    sha256 "d63b488a2dcfce5cd8a8c3da95278c7ce0f0e04b01c232d63ba1c87a6cde8afd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.1/rune-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cfcd133098fd3d801ec704ae49a68e4f0dcd5d0a28e56232caf46cdd2dec46db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.1/rune-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23dff945a7dd6c5076112f682fd2ef51223c4f53d149698fb6031ba08b3159ca"
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
