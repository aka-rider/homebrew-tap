class RuneEdit < Formula
  desc "TUI markdown editor and note-taking app"
  homepage "https://github.com/aka-rider/rune"
  version "1.0.1"
  license "MIT"

  on_arm do
    url "https://github.com/aka-rider/rune/releases/download/v#{version}/rune-darwin-arm64.tar.gz"
    sha256 "3cd307d61b9740d271ce40fe740d4f2a6fc49accb78296cd9b3e2bf63e0a2bf9"
  end

  on_intel do
    disable! date: "2026-06-18", because: "pre-built binary is Apple Silicon (arm64) only"
  end

  def install
    bin.install "rune"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rune --version")
  end
end
