# dotfiles

Repository for personal shell configuration files and installer.

## Included files

- `.bashrc`
- `.bash_profile` (minimal macOS login-shell loader)
- `.bash_aliases`
- `.bash_functions`
- `install.sh`

## Installer behavior

`install.sh` is a remote installer script that:

- ensures `git` is installed via Homebrew on macOS or APT on Debian and Ubuntu
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

## Migrating an existing Mac profile

Mac preferences are maintained in the macOS block of the shared `.bashrc`.
The Linux defaults and installer entry point remain unchanged.

Back up an existing `~/.bash_profile` before replacing it with the repository's
`.bash_profile`. The loader reads `.bashrc`, `.bash_aliases`, and `.bash_functions`
from `~/.dotfiles`. This directory can also be a symlink to a local checkout.
The installer only appends missing loader lines; it does not migrate an existing
profile's settings automatically.

On macOS, `a` edits the shared aliases and `b` edits the shared settings and
functions. `reload` loads the profile again. Login shells load this profile;
interactive non-login shells need a separate `~/.bashrc` loader if desired.

On macOS with Bash 4 or newer, Homebrew and kubectl completion load on the first
completion request, including requests handled by fzf. Bash 3.2 loads them at
startup because it has no default completion hook. Kubectl completion is cached
under `${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles`; a changed binary path or file
metadata invalidates the cache. If the cache cannot be written, completion is
generated in memory instead.
