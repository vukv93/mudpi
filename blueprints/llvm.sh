version=18
git clone --recursive https://github.com/llvm/llvm-project ~/src/llvm
cd ~/src/llvm
git switch release/$version.x
mkdir -p build
cd build
cmake \
  -DCMAKE_INSTALL_PREFIX=~/opt/stow/llvm-$version \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang \
  -DLLVM_BUILD_LLVM_DYLIB=on \
  -DLLVM_LINK_LLVM_DYLIB=on \
  -DCLANG_LINK_CLANG_DYLIB=on \
  -DLLVM_ENABLE_RTTI=on \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libc;libclc;lld;lldb;openmp" \
  -G Ninja \
  ../llvm
  # -DLLVM_ENABLE_PROJECTS=all \
cmake --build . --target install
stow -vR -d ~/opt/stow/ llvm-$version
