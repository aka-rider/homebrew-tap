# Maintained by .github/workflows/release-vuho.yml — the `version` and
# `sha256` lines are rewritten on every aka-rider/vuho release. Edit anything
# else here freely; those two are machine-owned.
cask "vuho" do
  version "0.9.1"

  on_macos do
    on_arm do
      sha256 "3f86c02f3016c300ca2207ba9043ccc36bcfd5505063629ea32d62f9bdd43cea"
      url "https://github.com/aka-rider/vuho/releases/download/v#{version}/Vuho-#{version}-arm64.tar.gz",
          verified: "github.com/aka-rider/vuho"
    end
  end

  name "Vuho"
  desc "Local-first speech-to-text dictation"
  homepage "https://github.com/aka-rider/vuho"

  livecheck do
    skip "Auto-generated on release."
  end

  # Apple Silicon and macOS 14+ only: the STT engine runs on the Neural Engine
  # via CoreML and the UI requires Metal.
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Vuho.app"

  # The release build is ad-hoc signed (no Developer ID), so Gatekeeper would
  # refuse to launch it while the download carries a quarantine xattr.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Vuho.app"] if OS.mac?
  end

  # Settings honour $XDG_CONFIG_HOME; ~/.config/vuho is the default location.
  # The ~474 MB model is downloaded at runtime into Application Support when
  # the cask build ships without it, so zap must remove it too.
  zap trash: [
    "~/.config/vuho",
    "~/Library/Application Support/Vuho",
  ]
end
