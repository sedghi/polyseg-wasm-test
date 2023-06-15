git clone https://bitbucket.org/icrimaginginformatics/polyseg-wasm.git

git clone --recursive https://gitlab.kitware.com/vtk/vtk.git vtk/src

# cd vtk/src git reset --hard efbe2afc2
# cd ../../

git clone https://github.com/PerkLab/PolySeg.git

docker run --rm --entrypoint /bin/bash -v ${PWD}:/work -it dockcross/web-wasm
