rm -rf /work/PolySeg/build
rm -rf /work/PolySeg/dist

mkdir /work/PolySeg/build
mkdir /work/PolySeg/dist

cmake \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DVTK_DIR=/work/vtk/build \
    -DOPTIMIZE=BEST \
    -B /work/PolySeg/build \
    /work/PolySeg/src
