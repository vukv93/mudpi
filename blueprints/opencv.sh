version=4
mkdir -p $HOME/src/opencv
cd $HOME/src/opencv
git clone https://github.com/opencv/opencv.git
git -C opencv switch $version.x
git clone https://github.com/opencv/opencv_contrib.git
git -C opencv_contrib switch $version.x
mkdir -p build
cmake \
  -DCMAKE_INSTALL_PREFIX=$HOME/opt/stow/opencv-$version.x \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules \
  -DCMAKE_C_COMPILER=$HOME/opt/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/opt/bin/clang++ \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=on \
  -S opencv -B build -G Ninja
cmake --build build \
  --target install
stow -vR -d ~/opt/stow/ opencv-$version.x
