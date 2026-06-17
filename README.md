# dotfiles

Repository for personal shell configuration files and installer.

## Included files

- `.bashrc`
- `.bash_aliases`
- `.bash_functions`
- `install.sh`

## Installer behavior

`install.sh` is a remote installer script that:

- ensures `git` is installed
- clones or updates the repository into `~/.dotfiles`
- copies dotfiles from `~/.dotfiles` into the user's home directory
- prompts once when existing target files are found
- sources `~/.bashrc` after a successful install

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

- Existing dotfiles are not overwritten without confirmation.
- The installer uses `cp -f` to copy files rather than creating symlinks.
- The repository is cloned into `~/.dotfiles`.
