#!/bin/bash
set -e

# 传入包路径参数，默认是 ../packages
PACKAGE_PATH=${1:-../packages}

# 若 PACKAGE_PATH 不存在就创建
if [ ! -d "$PACKAGE_PATH" ]; then
  echo "Creating package path: $PACKAGE_PATH"
  mkdir -p "$PACKAGE_PATH"
fi

cd "$PACKAGE_PATH"

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
