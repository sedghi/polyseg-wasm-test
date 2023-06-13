cmake \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DVTK_ENABLE_LOGGING:BOOL=OFF \
    -DVTK_ENABLE_WRAPPING:BOOL=OFF \
    -DVTK_LEGACY_REMOVE:BOOL=ON \
    -DVTK_OPENGL_USE_GLES:BOOL=OFF \
    -DVTK_USE_SDL2:BOOL=OFF \
    -DVTK_NO_PLATFORM_SOCKETS:BOOL=ON \
    -DVTK_MODULE_ENABLE_VTK_hdf5:STRING=NO \
    -DVTK_GROUP_ENABLE_Rendering:STRING=NO \
    -DVTK_GROUP_ENABLE_Views:STRING=NO \
    -DVTK_GROUP_ENABLE_Qt:STRING=NO \
    -DVTK_GROUP_ENABLE_Web:STRING=NO \
    -DVTK_GROUP_ENABLE_MPI:STRING=NO \
    -DVTK_SMP_ENABLE_STDTHREAD:BOOL=OFF \
    -B /work/vtk/build \
    /work/vtk/src