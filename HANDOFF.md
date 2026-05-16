# Handoff Instructions for Another Claude Code Instance

## What Was Done

Created a Windows port of `cgo` (Claude Code project navigator) from the Mac version.

### Branch: `windows`

This branch contains Windows-compatible modifications to make cgo work on Windows PowerShell and Command Prompt.

## Key Changes Made

### 1. **cgo script (main Python file)**
   - **Lines 15-35**: Replaced hardcoded Mac paths with cross-platform auto-detection
     - `CLAUDE_BINARY`: Now uses `shutil.which('claude')` to auto-detect from PATH
     - `SEARCH_ROOT`: Uses `CGO_SEARCH_ROOT` env var or defaults to user home
     - `CLONE_ROOT`: Uses `CGO_CLONE_DIR` env var or defaults to user home
     - `GITHUB_USER`: Auto-detects from `git config github.user` or uses env var
   - **Added Windows-specific directories to SKIP_DIRS**: AppData, ProgramData, etc.

   - **Lines 75-142**: Rewrote `find_claude_dirs()` function
     - **Original**: Used Unix `find` command subprocess
     - **New**: Uses Python `Path.iterdir()` for cross-platform compatibility
     - Implements recursive directory scanning with depth limit
     - Handles PermissionError gracefully on Windows

### 2. **install.ps1 (PowerShell installer)**
   - Created Windows equivalent of install.sh
   - Installs `windows-curses` package via pip (required for curses on Windows)
   - Creates `.bat` wrapper file for easy execution
   - Checks and warns if install dir not in PATH

### 3. **requirements.txt**
   - Added `windows-curses>=2.3.0` (only installs on Windows)

### 4. **Documentation**
   - README-WINDOWS.md: Complete Windows-specific documentation
   - HANDOFF.md: This file

## What Still Needs Doing

### Priority 1 - Testing
1. **Test basic functionality** on Windows 10/11
   - Install via PowerShell script
   - Verify it finds projects
   - Test all keyboard commands
   - Test clone functionality

2. **Test in different terminals**
   - Windows PowerShell 5.1
   - PowerShell 7
   - cmd.exe
   - Windows Terminal
   - Git Bash
   - VSCode integrated terminal

### Priority 2 - Performance
The Python directory scanning is likely slower than Unix `find`. Consider:

1. **Use `os.scandir()` instead of `Path.iterdir()`**
   ```python
   # Current (slower):
   for item in root.iterdir():

   # Faster alternative:
   import os
   with os.scandir(str(root)) as entries:
       for entry in entries:
           if entry.is_dir():
   ```

2. **Implement parallel scanning**
   - Use `ThreadPoolExecutor` to scan multiple subdirectories in parallel
   - Example pattern:
   ```python
   from concurrent.futures import ThreadPoolExecutor

   with ThreadPoolExecutor(max_workers=4) as executor:
       futures = [executor.submit(scan_directory, subdir) for subdir in subdirs]
   ```

3. **Optimize SKIP_DIRS checking**
   - Currently checks on every directory
   - Could pre-compile regex patterns for faster matching

### Priority 3 - Windows-Specific Improvements

1. **Add more Windows exclusions**
   - OneDrive directories
   - iCloud Drive
   - Dropbox cache
   - Windows.old
   - `$RECYCLE.BIN`

2. **Better color scheme for Windows Terminal**
   - Test with both light and dark themes
   - Windows Terminal has different color rendering than Mac Terminal

3. **Handle Windows path length limits**
   - Windows has 260 char path limit (unless long paths enabled)
   - Add error handling for `OSError: [WinError 206]`

### Priority 4 - Code Quality

1. **Add unit tests**
   - Test directory scanning logic
   - Test path encoding for Claude sessions
   - Mock filesystem for testing

2. **Add error handling**
   - Better error messages for Windows-specific issues
   - Handle antivirus interference gracefully
   - Handle network drives / UNC paths

3. **Code optimization**
   - Profile the scanning performance
   - Identify bottlenecks
   - Consider using `pathlib.Path.rglob()` with custom filter

## How to Continue This Work

### Step 1: Set Up
```powershell
cd C:\nick\ai\cgo
git checkout windows
```

### Step 2: Test Current Implementation
```powershell
# Install dependencies
pip install windows-curses

# Run directly
python cgo

# Or install and test
.\install.ps1
cgo
```

### Step 3: Make Improvements
Based on the priorities above, choose what to tackle. Recommended order:

1. **First**: Test thoroughly and document any bugs
2. **Second**: Fix any breaking bugs
3. **Third**: Optimize performance (if scanning is too slow)
4. **Fourth**: Polish UX (colors, error messages, etc.)

### Step 4: Update Documentation
- Update README-WINDOWS.md with any new findings
- Document any Windows-specific quirks discovered
- Update this HANDOFF.md if making significant changes

## Files Modified/Created

- ✏️ `cgo` - Main script (modified for cross-platform compatibility)
- ➕ `install.ps1` - PowerShell installer
- ➕ `requirements.txt` - Python dependencies
- ➕ `README-WINDOWS.md` - Windows documentation
- ➕ `HANDOFF.md` - This file

## Questions to Answer During Testing

1. **Performance**: How long does initial scan take on Windows vs Mac?
2. **Accuracy**: Does it find all Claude projects correctly?
3. **Stability**: Any crashes or hangs during normal use?
4. **UX**: Are the colors readable in different terminal themes?
5. **Edge cases**: What happens with:
   - Network drives
   - OneDrive/cloud-synced folders
   - Very deep directory trees
   - Symlinks/junctions
   - Permission-restricted folders

## Contact / Context

- Original repo: https://github.com/nickbeentjes/cgo
- This work done on: 2026-05-16
- Branch: `windows`
- Next step: Commit changes and optionally push to remote for testing

---

Good luck! The foundation is solid, just needs testing and polish. 🥔
