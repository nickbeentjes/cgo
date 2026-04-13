# cGo

Jump between Claude Code projects instantly.

![cgo demo](https://raw.githubusercontent.com/nickbeentjes/cgo/main/demo.gif)

## What it does

`cgo` scans your home directory for every project that has Claude Code activity (`.claude/` folders, `CLAUDE.md` files), shows them in a scrollable list, and launches `claude` in whichever one you pick — automatically passing `--continue` if there are saved conversations, or starting fresh if not.

```
  ⚡ cGo
  ~/code/my-api
  ~/code/my-app ✦
  ~/work/backend-service
  ~/work/mobile-app ✦

  ↑↓ navigate   enter launch   / filter   c clone   r rescan   q quit   [1/4]
```

(`✦` marks projects with a GSD planning directory.)

## Install

**One-liner:**
```sh
git clone git@github.com:nickbeentjes/cgo.git && cd cgo && ./install.sh
```

**Manual:**
```sh
cp cgo ~/.local/bin/cgo
chmod +x ~/.local/bin/cgo
```

Requires Python 3.9+ (ships with macOS). No dependencies.

## Usage

```sh
cgo
```

| Key | Action |
|-----|--------|
| `↑` / `↓` or `j` / `k` | Navigate |
| `Enter` | Launch `claude` in selected project |
| `/` | Filter list by typing |
| `c` | Clone a GitHub repo and open it |
| `r` | Rescan (cache expires after 1 hour automatically) |
| `q` / `Esc` | Quit |

### Clone mode (`c`)

Press `c`, then enter any of:
- `MyRepo` — clones `youruser/MyRepo` (detected from `git config github.user`)
- `otheruser/MyRepo` — clones from another user
- Full URL — `git@github.com:...` or `https://...`

Drops straight into a fresh Claude session after cloning.

## Configuration

All settings are optional env vars — cgo works with zero config out of the box.

| Variable | Default | Purpose |
|----------|---------|---------|
| `CGO_SEARCH_ROOT` | `$HOME` | Where to scan for projects |
| `CGO_CLONE_DIR` | `$HOME` | Where cloned repos land |
| `CGO_GITHUB_USER` | `git config github.user` | Default GitHub user for short repo names |

Example in `~/.zshrc`:
```sh
export CGO_CLONE_DIR="$HOME/code"
export CGO_GITHUB_USER="yourname"
```

## How it finds projects

Looks for:
- Directories containing a `.claude/` folder
- Directories containing a `CLAUDE.md` file

Automatically excludes the global `~/.claude` config directory, GSD worktrees, `node_modules`, `Library`, `DerivedData`, and other noise.

Results are cached at `~/.cache/cgo_dirs.txt` for 1 hour. Press `r` to force a rescan.

## License

MIT
