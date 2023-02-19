# platform specific environment variables
if [[ $(uname) == Darwin ]]; then
    export SO_EXT="dylib"
    export ENV_FILE_EXT="csh"
elif [[ "$target_platform" == linux-* ]]; then
    export SO_EXT="so"
    export ENV_FILE_EXT="sh"
    # source intel compiler for ESP/CAPS otherwise udpNaca456 doesn't compile
    # this may not work on other computers...
    source ~/intel/oneapi/setvars.sh > /dev/null
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
echo "ESP_ROOT = ${ESP_ROOT}"

declare modify_c=true
if [ $modify_c = true ]; then
    #change ESP_ROOT to CONDA_PREFIX in .c files so they work at runtime for anaconda
    find ./ -type f -name "*.c" -exec sed -i -e 's/ESP_ROOT/CONDA_PREFIX/g' {} \;

    #remake parts of ESP/CAPS and make part that isn't rebuilt
    echo "Remaking modified .c files"
    cd ${ESP_ROOT}/src/CAPS
    make
    cd ${ESP_ROOT}/src/OpenCSM
    make
fi

echo "Building AIM Module since rest is prebuilt"
cd ${ESP_ROOT}/src/CAPS/aim
make
cd ${SRC_DIR}

echo "Moving FILES..."
# move .h files to bin
# unfortunately can't put in esp-caps folder as python files have fixed cython refs inside
mv $ESP_ROOT/include/* $PREFIX/include/
find $ESP_ROOT/src/ -name '*.h' -exec cp -prv '{}' ${PREFIX}/include/ ';'
mv $CASROOT/include/opencascade/* $PREFIX/include/

# copy udunits2.xml file over and other xmls
# this may bug if the udunits has fixed path in c
find $ESP_ROOT/src/ -name '*.xml' -exec cp -prv '{}' ${PREFIX}/include/ ';'

# move .so files to lib
mv $ESP_ROOT/lib/*.${SO_EXT}* ${PREFIX}/lib/
mv $CASROOT/lib/*.${SO_EXT}* ${PREFIX}/lib/
echo "Done moving files!"

# copy executables from EngSketchPad and OpenCASCADE/bin to anaconda bin
mv $ESP_ROOT/bin/* ${PREFIX}/bin
mv $CASROOT/bin/* ${PREFIX}/bin

# recursively change python files to use CONDA_PREFIX not ESP_ROOT
# this way pyCAPS, pyEGADS files etc know where the header files are
find ./ -type f -exec sed -i -e 's/"ESP_ROOT"/"CONDA_PREFIX"/g' {} \;

# move python files to site-packages except the test files
mv $ESP_ROOT/pyESP/corsairlite ${SP_DIR}
mv $ESP_ROOT/pyESP/py* ${SP_DIR}
mv $ESP_ROOT/pyESP/* ${CONDA_PREFIX}/lib