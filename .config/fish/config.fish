
set -gx PATH ~/.local/share/texlive/2024/bin/x86_64-linux ~/develop/work/scripts ~/develop/flutter/sdk/bin ~/.local/share/nvim/mason/bin ~/.local/neovim/bin ~/.local/bin ~/.config/emacs/bin ~/.cargo/bin $PATH

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/serge/.ghcup/bin $PATH # ghcup-env

pyenv init - | source

