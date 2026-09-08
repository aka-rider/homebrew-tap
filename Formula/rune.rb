class Rune < Formula
  desc "TUI markdown editor that protects your words"
  homepage "https://github.com/aka-rider/rune"
  version "1.5.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aka-rider/rune/releases/download/v1.5.0/rune-cli-aarch64-apple-darwin.tar.xz"
    sha256 "288b7a5491360ac037ae53c45b14514016d9ee7a249192a2b5a788549658ea99"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.0/rune-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "951aeb1d99c7cac4b19f4ffaca28e1b490ddf35cbe187e0625017e9088998ea9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aka-rider/rune/releases/download/v1.5.0/rune-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ec6cb907b69c80c1c7531800a4fc302a746b2c5b41e2f7eecbb6a9bff87a36fd"
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
