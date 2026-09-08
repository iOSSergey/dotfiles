# dotfiles

Repository for personal shell configuration files and installer.

## Included files

- `.bashrc`
- `.bash_aliases`
- `.bash_functions`
- `install.sh`

## Installer behavior

`install.sh` is a remote installer script that:

- ensures `git` is installed via Homebrew on macOS or APT on Debian
- clones or updates the repository into `~/.dotfiles`
- keeps `.bashrc`, `.bash_aliases` and `.bash_functions` in `~/.dotfiles`
- updates `~/.bash_profile` on macOS or `~/.bashrc` on Debian and Ubuntu to source Bash files directly from `~/.dotfiles`

## Install via alias

Recommended alias for remote installation:

```bash
alias dotfiles='curl -fsSL https://raw.githubusercontent.com/iOSSergey/dotfiles/main/install.sh | bash'
```

Then run:

```bash
dotfiles
```

## Notes

- Existing `~/.bash_profile` or `~/.bashrc` content is not overwritten.
- The installer does not create symlinks.
- The repository is cloned into `~/.dotfiles`.
