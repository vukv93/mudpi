version=2.5.0
git clone https://github.com/sbcl/sbcl $HOME/src/sbcl
cd $HOME/src/sbcl
git checkout sbcl-$version -b sbcl-$version
sh make.sh --prefix=$HOME/opt/stow/sbcl-$version
sh install.sh
stow -vR -d $HOME/opt/stow/ sbcl-$version
