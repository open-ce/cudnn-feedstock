#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2023. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************

CUDNN_VERSION=${PKG_VERSION%%_*}
mkdir $PREFIX/include
mkdir -p $PREFIX/doc/nvidia/

SUB_DIR="cudnn"
ARCH=`uname -p`
if [[ "${ARCH}" == 'ppc64le' ]]; then
        SUB_DIR="${SUB_DIR}/targets/ppc64le-linux"
fi

cp $RECIPE_DIR/LICENSE $PREFIX/doc/nvidia/cuDNN_LICENSE
cp -r $SRC_DIR/${SUB_DIR}/lib*/ $PREFIX/lib/


# The archive has version subscripts meant to be used for
# the `alternatives` facility in Linux. No need for that here
# so we strip them out of the file names.

rename _v8 '' $SRC_DIR/${SUB_DIR}/include/*
cp -r $SRC_DIR/${SUB_DIR}/include $PREFIX
