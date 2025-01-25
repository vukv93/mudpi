version=7.1
nproc=$(cat /proc/cpuinfo | grep '^processor' | wc | awk {'print$1'})
toolpath=$HOME/opt/bin
git clone -b release/$version https://github.com/ffmpeg/ffmpeg $HOME/src/ffmpeg
cd $HOME/src/ffmpeg
./configure \
  --prefix=$HOME/opt/stow/ffmpeg-$version \
  --cc=$toolpath/clang \
  --cxx=$toolpath/clang++ \
  --enable-shared 
make -j$nproc
make install
stow -vR -d ~/opt/stow/ ffmpeg-$version
