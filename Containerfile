from docker.io/debian
# @todo[250121_141134] Mail server setup.
label author="vukv@nouua.com"
run apt update && apt upgrade -y
# @todo[250108_180155] Modularize.
run apt install -y bash git sbcl curl tmux rlwrap gawk build-essential locales
run apt install -y bash-completion clang cmake doxygen w3m nodejs stow man btop
run apt install -y gdb valgrind nasm patchelf pahole clangd ninja-build
run apt install -y gettext iproute2 netcat-openbsd tcpdump gpg bsdutils cowsay
run apt install -y graphviz imagemagick pandoc texlive-xetex texlive-luatex
run apt install -y cabal-install
# @todo[250105_165649] X11 setup, connecting to host on run.
# run apt install -y xbomb
# @todo[250105_165715] Audio setup, Pipewire or JACK.
# run apt install -y pipewire
# @todo[250124_033819] Make the above two optional.
run echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
run locale-gen
run curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
run curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
run curl https://beta.quicklisp.org/quicklisp.lisp >> /opt/quicklisp.lisp
run sbcl --load /opt/quicklisp.lisp --eval '(quicklisp-quickstart:install)'
arg RERUNFROM=nil
add blueprints /blueprints
run bash /blueprints/llvm.sh
run bash /blueprints/boost.sh
run bash /blueprints/tree-sitter.sh
run bash /blueprints/neovim.sh
run bash /blueprints/opencv.sh
run bash /blueprints/ffmpeg.sh
run bash /blueprints/sbcl.sh
run bash /blueprints/ftxui.sh
# @todo[250121_135718] Yocto blueprint.
# @todo[250124_033729] SuperCollider blueprint.
cmd bash
