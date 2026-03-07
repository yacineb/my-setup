# Terminal-First Dev Setup

A lightweight, keyboard-driven development environment replacing Cursor/VSCode.

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
- `p` — push
- `i` — interactive rebase
- `?` — full keybinding list

## Customization

All configs live in `~/.config/<tool>/`. Edit them directly or re-run the setup script sections you need.
