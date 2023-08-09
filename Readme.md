# Usage

With fish as default shell:
```
git clone --bare git@github.com:iSerge/dotfiles.git $HOME/dotfiles
git --git-dir $HOME/dotfiles --work-tree $HOME checkout -f
config config --local status.showUntrackedFiles no
```

For use with other shells setup following alias:
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
