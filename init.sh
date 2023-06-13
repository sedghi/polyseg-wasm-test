git clone https://bitbucket.org/icrimaginginformatics/polyseg-wasm.git

git clone --recursive https://gitlab.kitware.com/vtk/vtk.git vtk/src

git clone https://github.com/PerkLab/PolySeg.git

docker run --rm --entrypoint /bin/bash -v ${PWD}:/work -it dockcross/web-wasm
