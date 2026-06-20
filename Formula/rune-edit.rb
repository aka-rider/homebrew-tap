class RuneEdit < Formula
  desc "TUI markdown editor and note-taking app"
  homepage "https://github.com/aka-rider/rune"
  version "1.0.0"
  license "MIT"

  on_arm do
    url "https://github.com/aka-rider/rune/releases/download/v#{version}/rune-darwin-arm64.tar.gz"
    # sha256 is populated after running the rune release workflow — update before first install
    sha256 "d09798e0ee73b95aa0b3b4042916fbb72f33182a140e5932eef5700543e10033"
  end

  on_intel do
    disable! date: "2026-06-18", because: "pre-built binary is Apple Silicon (arm64) only"
  end

  depends_on "libgit2"  # runtime: binary dynamically links libgit2.dylib

  def install
    bin.install "rune"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rune --version")
  end
end
