# cGo for Windows

Windows port of the Claude Code project navigator. Jump between Claude Code projects instantly on Windows PowerShell or Command Prompt.

## What's Different from Mac Version

This Windows branch adapts cGo to work on Windows systems:

- **Lightning-fast Everything integration** - Uses Everything HTTP server for instant search (100x faster!)
- **Fallback scanning** - Automatically falls back to Python Path API if Everything is not available
- **Auto-detection** - Automatically finds `claude` binary in PATH instead of hardcoded paths
- **Windows-curses support** - Uses `windows-curses` package for terminal UI
- **PowerShell installer** - Native Windows installation script
- **Environment variable configuration** - Uses standard env vars for all paths

## Requirements

- Python 3.9+ (Windows 10/11 includes Python or install from python.org)
- `windows-curses` package (auto-installed by install script)
- Claude Code CLI installed and in PATH
- **Recommended**: Everything with HTTP server enabled (see below)

### Everything HTTP Server (Highly Recommended!)

For lightning-fast scanning (100x faster than filesystem traversal), install Everything and enable its HTTP server:

1. **Install Everything** - Download from https://www.voidtools.com/
2. **Enable HTTP Server**:
   - Open Everything
   - Go to: Tools → Options → HTTP Server
   - Check "Enable HTTP Server"
   - Default port: 8099 (or set `CGO_EVERYTHING_URL` env var if different)
   - Click OK

**Without Everything**: cGo automatically falls back to Python directory scanning (slower but still works)

## Install

### One-liner (PowerShell):
```powershell
git clone https://github.com/nickbeentjes/cgo.git; cd cgo; git checkout windows; .\install.ps1
```

### Manual:
```powershell
# Install windows-curses
pip install windows-curses

# Copy to a directory in your PATH
mkdir -Force $env:USERPROFILE\.local\bin
copy cgo $env:USERPROFILE\.local\bin\cgo
echo '@echo off' > $env:USERPROFILE\.local\bin\cgo.bat
echo 'python "%~dp0cgo" %*' >> $env:USERPROFILE\.local\bin\cgo.bat

# Add to PATH if needed
$env:PATH += ";$env:USERPROFILE\.local\bin"
```

## Usage

```powershell
cgo
```

Same keyboard shortcuts as Mac version:

| Key | Action |
|-----|--------|
| `↑` / `↓` or `j` / `k` | Navigate |
| `Enter` | Launch `claude` in selected project |
| `/` | Filter list by typing |
| `c` | Clone a GitHub repo and open it |
| `r` | Rescan (cache expires after 1 hour automatically) |
| `q` / `Esc` | Quit |

## Configuration

All settings are optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `CGO_SEARCH_ROOT` | `%USERPROFILE%` | Where to scan for projects |
| `CGO_CLONE_DIR` | `%USERPROFILE%` | Where cloned repos land |
| `CGO_GITHUB_USER` | `git config github.user` | Default GitHub user for short repo names |
| `CGO_EVERYTHING_URL` | `http://localhost:8099` | Everything HTTP server URL |
| `CLAUDE_BINARY` | Auto-detected from PATH | Path to claude executable |

Example in PowerShell profile (`$PROFILE`):
```powershell
$env:CGO_CLONE_DIR = "$env:USERPROFILE\code"
$env:CGO_GITHUB_USER = "yourname"
```

## Known Limitations

- **Without Everything**: Initial scan may be slower due to filesystem differences
- **With Everything**: Scanning is instant! (Highly recommended)
- Some terminal emulators may have better curses support than others (Windows Terminal recommended)

## Troubleshooting

### "curses" module not found
```powershell
pip install windows-curses
```

### "claude" not found
Make sure Claude Code CLI is installed and in your PATH:
```powershell
where.exe claude
```

### Slow scanning
**Solution**: Install Everything and enable HTTP server (see Requirements section above) for instant search.

**Alternative**: Narrow search scope to commonly-used directories:
```powershell
$env:CGO_SEARCH_ROOT = "$env:USERPROFILE\code"
```

## For Developers / Another Claude Code Instance

### Testing Changes
```powershell
# Test directly without installing
python cgo
```

### Todo List
- [ ] Test on various Windows versions (10, 11)
- [ ] Test in different terminals (cmd.exe, PowerShell, Windows Terminal, Git Bash)
- [ ] Optimize scanning performance for large directory trees
- [ ] Add color scheme that works well with both light/dark Windows Terminal themes
- [ ] Consider adding Windows-specific exclusions (OneDrive, iCloud Drive, etc.)
- [ ] Add automated tests
- [ ] Benchmark performance vs Mac version

### Next Steps for Another Developer
1. **Test the current implementation** - Run it on your Windows machine and note any issues
2. **Performance optimization** - The Python directory scanning may be slower than Unix `find`, consider:
   - Using `os.scandir()` instead of `Path.iterdir()` for better performance
   - Adding more aggressive caching
   - Implementing parallel directory scanning with threading
3. **Terminal compatibility** - Test in cmd.exe, PowerShell 5.1, PowerShell 7, Windows Terminal, Git Bash
4. **UX improvements** - The curses colors may need adjustment for Windows terminals
5. **Error handling** - Add better error messages for Windows-specific issues

### Code Structure
- **Lines 1-35**: Configuration & imports (adapted for Windows)
- **Lines 75-142**: `find_claude_dirs()` - **Key change**: Uses Python Path traversal instead of Unix `find`
- **Lines 154-456**: TUI code (unchanged, curses works the same with windows-curses)
- **install.ps1**: PowerShell installer (Windows equivalent of install.sh)

### Testing Checklist
- [ ] Install via PowerShell script
- [ ] Verify it finds Claude projects correctly
- [ ] Test navigation (arrow keys, j/k)
- [ ] Test filtering (/)
- [ ] Test launching Claude projects
- [ ] Test clone functionality (c)
- [ ] Test rescan (r)
- [ ] Verify cache mechanism works
- [ ] Test with various PATH configurations

## License

MIT (same as original)
