class Rune < Formula
  desc "TUI markdown editor that protects your words"
  homepage "https://github.com/aka-rider/rune"
  version "1.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aka-rider/rune/releases/download/v1.4.0/rune-cli-aarch64-apple-darwin.tar.xz"
    sha256 "626de2de860cf04af6da158080fdc85ad374ff67977608cb704c13b0e2039ca7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aka-rider/rune/releases/download/v1.4.0/rune-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef8c2a8f87a643b2dbafe1ec8a53cb5bb4408025f67abe7b2a45240d9fe41268"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aka-rider/rune/releases/download/v1.4.0/rune-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e29b7dc78a7195fbdfab5f38c73cae38ff4c6ba28fe8253157d077451da30684"
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
