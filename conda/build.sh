# export SRC_DIR=~/git/esp-beta
# export ESP_ROOT=${SRC_DIR}
# echo "ESP_ROOT = ${ESP_ROOT}"

# # assumes opencascade conda package installed in conda env ESP
# ${ESP_ROOT}/config/makeEnv ~/anaconda3/envs/ESP
# do a wget here for the ESP122

# # source and build ESP/CAPS
# source ${ESP_ROOT}/ESPenv.sh
# export ESP_ROOT=${SRC_DIR}
# echo "ESP_ROOT = ${ESP_ROOT}"
# cd ${ESP_ROOT}/src && make

# export TACS_DIR=${SRC_DIR}

# if [[ $(uname) == Darwin ]]; then
#   export SO_EXT="dylib"
#   export SO_LINK_FLAGS="-fPIC -dynamiclib"
#   export LIB_SLF="${SO_LINK_FLAGS} -install_name @rpath/libtacs.dylib"
#   export F5TOVTK_SLF="${SO_LINK_FLAGS} -install_name @rpath/f5tovtk"
#   export LAPACK_LIBS="-framework accelerate"
# elif [[ "$target_platform" == linux-* ]]; then
#   export SO_EXT="so"
#   export SO_LINK_FLAGS="-fPIC -shared"
#   export LIB_SLF="${SO_LINK_FLAGS}"
#   export F5TOVTK_SLF="${SO_LINK_FLAGS}"
#   export LAPACK_LIBS="-L${PREFIX}/lib/ -llapack -lpthread -lblas"
# fi

# if [[ $scalar == "complex" ]]; then
#   export OPTIONAL="complex"
#   export PIP_FLAGS="-DTACS_USE_COMPLEX"
# elif [[ $scalar == "real" ]]; then
#   export OPTIONAL="default"
# fi

# cp Makefile.in.info Makefile.in;
# make ${OPTIONAL} TACS_DIR=${TACS_DIR} \
#      LAPACK_LIBS="${LAPACK_LIBS}" \
#      METIS_INCLUDE=-I${PREFIX}/include/ METIS_LIB="-L${PREFIX}/lib/ -lmetis" \
#      SO_LINK_FLAGS="${LIB_SLF}" SO_EXT=${SO_EXT};
# mv ${TACS_DIR}/lib/libtacs.${SO_EXT} ${PREFIX}/lib;

# # Recursively copy all header files
# mkdir ${PREFIX}/include/tacs;
# find ${TACS_DIR}/src/ -name '*.h' -exec cp -prv '{}' ${PREFIX}/include/tacs ';'

# CFLAGS=${PIP_FLAGS} ${PYTHON} -m pip install --no-deps --prefix=${PREFIX} . -vv;

# cd ${TACS_DIR}/extern/f5tovtk;
# make default TACS_DIR=${TACS_DIR} \
#              LAPACK_LIBS="${LAPACK_LIBS}" \
#              METIS_INCLUDE=-I${PREFIX}/include/ METIS_LIB="-L${PREFIX}/lib/ -lmetis" \
#              SO_LINK_FLAGS="${F5TOVTK_SLF}" SO_EXT=${SO_EXT};
# mv ./f5tovtk ${PREFIX}/bin;

# cd ${TACS_DIR}/extern/f5totec;
# make default TACS_DIR=${TACS_DIR} \
#              TECIO_INCLUDE=${PREFIX}/include TECIO_LIB=${PREFIX}/lib/libtecio.a \
#              LAPACK_LIBS="${LAPACK_LIBS}" \
#              METIS_INCLUDE=-I${PREFIX}/include/ METIS_LIB="-L${PREFIX}/lib/ -lmetis" \
#              SO_LINK_FLAGS="${F5TOVTK_SLF}" SO_EXT=${SO_EXT};
# mv ./f5totec ${PREFIX}/bin;

