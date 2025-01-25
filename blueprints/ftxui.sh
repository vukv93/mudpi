version=5.0.0
tooldir=$HOME/opt/bin
git clone https://github.com/arthursonzogni/ftxui $HOME/src/ftxui
cd $HOME/src/ftxui
git checkout v$version -b v$version
mkdir build 
cd build
cmake \
  -DCMAKE_INSTALL_PREFIX=$HOME/opt/stow/ftxui-$version \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=$tooldir/clang++ \
  -DCMAKE_C_COMPILER=$tooldir/clang \
  -G Ninja ../
cmake --build . --target install
stow -vR -d $HOME/opt/stow/ ftxui-$version
