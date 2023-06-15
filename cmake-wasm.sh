rm -rf /work/polyseg-wasm/build
rm -rf /work/polyseg-wasm/dist

mkdir /work/polyseg-wasm/build
mkdir /work/polyseg-wasm/dist

scp ./CMakeLists.txt /work/polyseg-wasm/src/CMakeLists.txt

cmake \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DVTK_DIR=/work/vtk/build \
    -DOPTIMIZE=BEST \
    -B /work/polyseg-wasm/build \
    /work/polyseg-wasm/src
