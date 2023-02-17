
# platform specific environment variables
if [[ $(uname) == Darwin ]]; then
    export SO_EXT="dylib"
    export ENV_FILE_EXT="csh"
elif [[ "$target_platform" == linux-* ]]; then
    export SO_EXT="so"
    export ENV_FILE_EXT="sh"
fi

# set main ESP environment variable
export ESP_ROOT=${SRC_DIR}/EngSketchPad
echo "ESP_ROOT = ${ESP_ROOT}"
cd ${ESP_ROOT}

echo "Setting up ESP environment and linking with OpenCASCADE"
# predefine environment variables so that the ESPenv.sh script doesn't break later
export CASROOT=${SRC_DIR}/OpenCASCADE-7.6.0
export CASARCH=
export ESPARCH=
export AFLR=
export PATH=$PATH:$CASROOT/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CASROOT/lib

# run the environment configure shell script
./config/makeEnv ${CASROOT}
source ${SRC_DIR}/ESPenv.${ENV_FILE_EXT}
echo "Done setting up ESP environment"

# build the aim modules
echo "Building AIM Module since rest is prebuilt"
cd ${ESP_ROOT}/src/CAPS/aim/
make
cd ${SRC_DIR}

# copy executables from EngSketchPad and OpenCASCADE/bin to anaconda bin
mv $ESP_ROOT/bin/* ${PREFIX}/bin
mv $CASROOT/bin/* ${PREFIX}/bin

# move .h files to bin
# unfortunately can't put in esp-caps folder as python files have fixed cython refs inside
mv $ESP_ROOT/include/ $PREFIX/include/
find $ESP_ROOT/src/ -name '*.h' -exec cp -prv '{}' ${PREFIX}/include/ ';'
# maybe it is bad to have too many files in main include/ ?
mv $CASROOT/include/opencascade $PREFIX/include/

# move .so files to lib
mv $ESP_ROOT/lib/*.${SO_EXT}* ${PREFIX}/lib/
mv $CASROOT/lib/*.${SO_EXT}* ${PREFIX}/lib/

# move python files to site-packages
mv $ESP_ROOT/pyESP/* ${SP_DIR}

export ESP_ROOT=${PREFIX}
echo "ESP_ROOT = ${PREFIX}"