#!/bin/bash
set -e

cd ../packages

BUILD_DIR="build"
ZIP_NAME="default_viewer_request_handler.zip"

# 清理旧文件
rm -rf $BUILD_DIR $ZIP_NAME
mkdir -p $BUILD_DIR

# 安装依赖
pip install -r ../lambda/edge/requirements.txt -t $BUILD_DIR

# 拷贝函数代码
cp ../lambda/edge/default_viewer_request_handler.py $BUILD_DIR/

# 打包为 lambda zip 文件
cd $BUILD_DIR

# 只在 ZIP 文件存在时才删除
[ -f "../$ZIP_NAME" ] && rm "../$ZIP_NAME"

zip -r ../$ZIP_NAME .
