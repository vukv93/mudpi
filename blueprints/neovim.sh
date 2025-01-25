version=0.10
toolchain=$HOME/opt/bin
git clone --recursive https://github.com/neovim/neovim $HOME/src/neovim
cd $HOME/src/neovim
git switch release-$version
make \
  CMAKE_INSTALL_PREFIX=$HOME/opt/stow/nvim-$version/ \
  CMAKE_BUILD_TYPE=RelWithDebInfo \
  CMAKE_EXTRA_FLAGS="-DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_C_COMPILER=$toolchain/clang -DCMAKE_CXX_COMPILER=$toolchain/clang++"
  DEPS_CMAKE_FLAGS="-DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_C_COMPILER=$toolchain/clang -DCMAKE_CXX_COMPILER=$toolchain/clang++"
mkdir -p $HOME/opt/stow/
make install
stow -vR -d $HOME/opt/stow/ nvim-$version
