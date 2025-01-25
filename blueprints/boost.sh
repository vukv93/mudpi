version=1.87.0
git clone --recursive https://github.com/boostorg/boost ~/src/boost
cd ~/src/boost
git checkout -b boost-$version boost-$version
./bootstrap.sh --prefix=$HOME/opt/stow/boost-$version
cat <<EOF >> project-config.jam
using clang : : $HOME/opt/bin/clang++ ;
EOF
./b2 toolset=clang install
stow -vR -d ~/opt/stow/ boost-$version
