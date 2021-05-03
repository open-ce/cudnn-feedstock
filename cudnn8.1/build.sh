#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2018, 2021. All Rights Reserved.
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
mkdir -p $PREFIX/lib64
mkdir -p $PREFIX/cuda/lib

cp $RECIPE_DIR/LICENSE $PREFIX/doc/nvidia/cuDNN_LICENSE
cp -r $SRC_DIR/cudnn/lib64/ $PREFIX/lib/


# The dev RPM package has version subscripts meant to be used for
# the `alternatives` facility in Linux. No need for that here
# so we strip them out of the file names.

rename _v8 '' $SRC_DIR/cudnn-dev/include/*
cp $SRC_DIR/cudnn-dev/lib64/libcudnn_static*.a $PREFIX/lib/libcudnn_static.a
cp -r $SRC_DIR/cudnn-dev/include $PREFIX

ln -s $PREFIX/lib/libcudnn.so.$CUDNN_VERSION $PREFIX/lib/libcudnn.so

for link_loc in lib64 cuda/lib; do
    ln -s $PREFIX/lib/libcudnn.so.$CUDNN_VERSION $PREFIX/$link_loc/libcudnn.so
    ln -s $PREFIX/lib/libcudnn_static.a $PREFIX/$link_loc/libcudnn_static.a
    for f in $SRC_DIR/cudnn/lib64/*.so*; do
        filename=`basename $f`
        ln -s $PREFIX/lib/$filename $PREFIX/$link_loc/$filename
    done
done
