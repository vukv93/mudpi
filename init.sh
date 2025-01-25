#!/usr/bin/env bash
# To run at continer creation time.
statedir=${XDG_STATE_HOME:-$HOME/.local/state}/mudpi
if [ ! -d $statedir ]; then
  rm -rf ~/.bashrc ~/.ssh ~/.gitconfig
  stow -v -R --dotfiles -d /mudpi -t ~ home
  mkdir -p ~/{bin,common-lisp,opt,src}
  if [ ! -e ~/common-lisp/mudpi/ ]; then ln -s /mudpi ~/common-lisp/mudpi; fi
  cat <<EOF >> ~/.gitconfig
[init]
  defaultBranch = root
[pull]
  ff = only
[user]
  email = ${MUDPI_USER}@${MUDPI_CONT}
  name = $MUDPI_USER
EOF
  mkdir -p $statedir
  # @todo[250108_144217] Tests.
fi
/usr/games/cowsay "You are now in a mudpi."
bash
