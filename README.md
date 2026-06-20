# aka-rider/tap

Homebrew tap for [rune](https://github.com/aka-rider/rune) and its dictation dependency.

## Install

```sh
brew tap aka-rider/tap
```

### rune — TUI markdown editor

```sh
brew install aka-rider/tap/rune-edit
rune --version
```

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

## Formulas

| Formula | Description |
|---------|-------------|
| `rune-edit` | TUI markdown editor (pre-built arm64 binary) |
| `whisper-cpp-server` | OpenAI Whisper HTTP server with VAD and Metal acceleration (pre-built arm64 binary) |
| `whisper-cpp-large-v3-turbo` | Whisper large-v3-turbo GGML model |
| `whisper-cpp-silero-vad` | Silero VAD GGML model |

All pre-built binaries are Apple Silicon (arm64) only. Intel Macs are not supported.
