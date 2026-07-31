# aka-rider/tap

Homebrew tap for [rune](https://github.com/aka-rider/rune), [vuho](https://github.com/aka-rider/vuho),
[leash](https://github.com/aka-rider/leash), and rune's dictation dependency.

## Install

```sh
brew tap aka-rider/tap
```

Casks and formulas below are given as `brew install aka-rider/tap/<name>`, which auto-taps
`aka-rider/tap` if it isn't already. If you ran `brew tap aka-rider/tap` first (or plan to
install more than one item from this tap), the unqualified `brew install --cask <name>` /
`brew install <name>` also works.

Recent Homebrew versions require non-official taps to be trusted before their formulae or casks
are loaded (`HOMEBREW_REQUIRE_TAP_TRUST`, on by default). If `brew install` refuses to load
anything from this tap, run:

```sh
brew trust aka-rider/tap
```

### rune — TUI markdown editor

```sh
brew install aka-rider/tap/rune-edit
rune --version
```

### vuho — local-first speech-to-text dictation

```sh
brew install --cask aka-rider/tap/vuho
```

Apple Silicon (arm64) and macOS Sonoma (14.0) or later only. On first launch, a setup window
asks before Vuho downloads its ~474 MB Parakeet-TDT speech model into
`~/Library/Application Support/Vuho/models`; nothing is fetched until you approve it there.
Vuho needs Microphone, Accessibility, and Input Monitoring — grant them when macOS prompts.
Because releases are ad-hoc signed (no Apple Developer ID), each upgrade changes the app's code
signature and macOS re-prompts for all three permissions again.

### leash — transparent seatbelt sandbox

```sh
brew install aka-rider/tap/leash
```

Wraps any command in a macOS seatbelt sandbox; installs the `leash` and `leash-trace` binaries.

### whisper-server — dictation backend (optional)

rune's dictation feature posts audio to a local HTTP server on `127.0.0.1:8080`.
Three formulas are needed: the server binary, the transcription model, and the VAD model.

```sh
brew install aka-rider/tap/whisper-cpp-server
```

This pulls in `whisper-cpp-large-v3-turbo` and `whisper-cpp-silero-vad` automatically.

Start it as a background service:

```sh
brew services start aka-rider/tap/whisper-cpp-server
```

**RAM:** whisper-cpp-server loads ~1.6 GB of model weights into RAM at runtime.

Or run it directly:

```sh
whisper-cpp-service          # uses config at $(brew --prefix)/etc/whisper-cpp-server/config
```

Health check:

```sh
curl http://127.0.0.1:8080/health
```

Config file (edit port, threads, model paths, then restart):

```sh
$(brew --prefix)/etc/whisper-cpp-server/config
```

## Formulas & casks

| Name | Type | Description |
|------|------|-------------|
| `rune-edit` | cask | TUI markdown editor (pre-built arm64 binary) |
| `vuho` | cask | Local-first, fully private speech-to-text dictation (pre-built arm64 app; downloads its speech model on first run) |
| `leash` | cask | Transparent macOS seatbelt sandbox for any command (pre-built universal binary) |
| `whisper-cpp-server` | formula | OpenAI Whisper HTTP server with VAD and Metal acceleration (pre-built arm64 binary) |
| `whisper-cpp-large-v3-turbo` | formula | Whisper large-v3-turbo GGML model |
| `whisper-cpp-silero-vad` | formula | Silero VAD GGML model |

All pre-built binaries are Apple Silicon (arm64) only. Intel Macs are not supported.
