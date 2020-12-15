# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2018, 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************
#!/bin/bash

CUDNN_VERSION=${PKG_VERSION%%_*}
mkdir $PREFIX/include
mkdir -p $PREFIX/doc/nvidia/
mkdir -p $PREFIX/lib64
mkdir -p $PREFIX/cuda/lib

cp $RECIPE_DIR/LICENSE $PREFIX/doc/nvidia/cuDNN_LICENSE
cp -r $SRC_DIR/cudnn/lib64/ $PREFIX/lib/

# The dev RPM package has version subscripts meant to be used for
# the `alternatives` facility in Linux. No need for that here
# so we strip them out of the file names during the copy.

cp -r $SRC_DIR/cudnn-dev/include/cudnn*.h $PREFIX/include/cudnn.h
cp $SRC_DIR/cudnn-dev/lib64/libcudnn_static*.a $PREFIX/lib/libcudnn_static.a

ln -s $PREFIX/lib/libcudnn.so.$CUDNN_VERSION $PREFIX/lib/libcudnn.so

for link_loc in lib64 cuda/lib; do
    ln -s $PREFIX/lib/libcudnn.so.$CUDNN_VERSION $PREFIX/$link_loc/libcudnn.so
    ln -s $PREFIX/lib/libcudnn_static.a $PREFIX/$link_loc/libcudnn_static.a
    for f in $SRC_DIR/cudnn/lib64/*.so*; do
        filename=`basename $f`
        ln -s $PREFIX/lib/$filename $PREFIX/$link_loc/$filename
    done
done
