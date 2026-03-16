# Terminal-First Dev Setup

A lightweight, keyboard-driven development environment replacing Cursor/VSCode.

For pure nerds — a 360° dev experience in pure terminal. No Electron, no GUI, no mouse. Just your keyboard, a grid of panes, and blazing-fast tools that do one thing well. Edit, navigate, search, diff, commit — all without ever leaving the terminal.

## The Stack

| Tool | Role | Replaces |
|------|------|----------|
| **Ghostty** | Terminal emulator | iTerm2 / Terminal.app |
| **Zellij** | Session/pane manager | tmux / VSCode panels |
| **Helix** | Modal editor with built-in LSP | VSCode / Cursor editor |
| **Yazi** | Terminal file manager | VSCode sidebar |
| **Lazygit** | Git TUI | GitLens / Source Control |
| **Starship** | Shell prompt | oh-my-zsh themes |
| **zoxide** | Smart directory jumper | manual `cd` |
| **ripgrep** | Fast search | VSCode search |
| **fd** | Fast file finder | `find` |
| **bat** | Cat with syntax highlighting | `cat` |
| **delta** | Better git diffs | default diff |
| **ec** | Terminal 3-way merge tool | opendiff / VS Code merge |
| **nb** | CLI note-taking & bookmarking | Notion / Obsidian |

## Quick Start

```bash
chmod +x setup.sh
./setup.sh
```

The script will:
1. Install all tools via Homebrew
2. Create config directories
3. Write default configs for Ghostty, Helix, Zellij, Yazi, Starship, and Lazygit
4. Set up shell integration (zoxide, starship) in `.zshrc`

## Post-Install

- Run `hx --tutor` to learn Helix keybindings (selection-first model)
- Run `lazygit` in any git repo to explore the UI
- Run `yazi` to browse files (press `q` to quit, `o` to open in Helix)
- Press `?` in lazygit/yazi for keybinding help

## Key Workflows

### Editing (Helix)
- `hx .` — open current directory
- `Space + f` — file picker (fuzzy find)
- `Space + /` — global search (ripgrep)
- `Space + k` — hover docs
- `gd` — go to definition
- `gr` — go to references
- `Ctrl+s` — quick save
- `H` / `L` — previous / next buffer
- `Ctrl+w` — close buffer
- `Space + m` — markdown preview (glow in Zellij pane)

### Pane Management (Zellij)
- `Ctrl+p` then arrow keys — navigate panes
- `Ctrl+p` then `n` — new pane
- `Ctrl+t` then `n` — new tab
- `Ctrl+o` then `w` — floating pane toggle

### File Navigation (Yazi)
- `h/l` — parent/child directory
- `j/k` — up/down
- `o` — open file
- `/` — search
- `Space` — select files

### Git (Lazygit)
- `Space` — stage/unstage file
- `c` — commit
- `C` — commit with gitmoji
- `p` — push
- `i` — interactive rebase
- `M` — resolve merge conflicts with `ec` (on selected file)
- `?` — full keybinding list

## LSP Integration (Helix)

Helix has **built-in LSP support** — no plugins, no extensions, no fiddling. It just works out of the box. This is what makes the experience amazing compared to Vim/Neovim setups that require dozens of plugins to get basic IDE features.

### What you get for free
- **Inline diagnostics** — errors and warnings displayed right on the cursor line (`hint` level) and across the file (`error` level)
- **Inlay hints** — type annotations and parameter names rendered inline
- **Hover docs** — `Space + k` shows documentation without leaving the editor
- **Go to definition / references** — `gd` / `gr`, instant navigation
- **Auto-format on save** — enabled per language
- **Code actions** — `Space + a` to apply quick fixes and refactors
- **Completions** — instant (5ms timeout), no lag

### Pre-configured language servers

| Language | Server(s) |
|----------|-----------|
| Rust | `rust-analyzer` (with clippy) |
| Python | `ruff` + `pyright` |
| TypeScript/TSX | `typescript-language-server` |
| TOML/YAML/Bash | Built-in support with auto-format |
| All languages | `helix-gpt` (Codeium AI completions) |

No `mason.nvim`, no `lspconfig`, no `coc.nvim` — just a clean `languages.toml` and you're done.

### Codeium AI completions (helix-gpt)

All languages get AI-powered code completions via [helix-gpt](https://github.com/leona/helix-gpt) with the Codeium backend.

**First-time auth setup:**

1. Run the auth script:
   ```bash
   ./scripts/bin/codeium-auth
   # Or with bun: bun ~/.local/bin/helix-gpt.js --authCodeium
   ```
2. Open the URL it prints in your browser and log in to Codeium
3. Copy the token shown on the page and paste it into the **terminal prompt** (not `.zshrc`)
4. The script prints your **real API key** — save that:
   ```bash
   echo 'export CODEIUM_API_KEY="<the-key-from-step-3>"' >> ~/.zshrc
   source ~/.zshrc
   ```

> **Note:** The token from the Codeium website (`ott$...`) is a one-time token, not the API key. The auth script exchanges it for the real key. These tokens expire in seconds, so paste it quickly.

**Usage in Helix:**
- Completions trigger automatically on `{`, `(`, or space
- `Ctrl+x` in insert mode to trigger manually
- A "Fetching completion..." diagnostic appears while loading

> **Note:** helix-gpt runs on Node.js instead of Bun due to a Bun stdin bug when spawned as a subprocess. The wrapper at `~/.local/bin/helix-gpt` handles this automatically.

## Customization

All configs live in `~/.config/<tool>/`. Edit them directly or re-run the setup script sections you need.
