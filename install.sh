#!/bin/sh

ZERO_MANIFEST_PATH=$(pwd)
PROJECT_PATH=$ZERO_MANIFEST_PATH/..
ZERO_SDK_NAME=zero-mcu
ZERO_SDK_HOME=$PROJECT_PATH/$ZERO_SDK_NAME
debug_flag="off"

Usage()
{
cat <<EOF
$0 [VERSION] [DEBUG]
    VERSION: A.B
    DEBUG: 'on'/'off'

example:
    $0 0.1
EOF
exit 0
}

VERSION=0.1

if [ $# -eq 1 ]; then
    if [ $1 = "?" ] || [ $1 = "-h" ]; then
        Usage
    fi
elif [ $# -gt 1 ]; then
    if [ $2 == "on" ]; then
        debug_flag="on"
    fi
    VERSION=$1
fi

echo "Enter $PROJECT_PATH/"
cd $PROJECT_PATH

echo "install zero-mcu version: $VERSION ..."

if [ ! -d $ZERO_SDK_HOME ]; then
    echo "create $ZERO_SDK_HOME"
    mkdir $ZERO_SDK_HOME
else
    echo "$ZERO_SDK_HOME already exists, clean the folder first."
    rm -rf $ZERO_SDK_HOME/*
    rm -rf $ZERO_SDK_HOME/.repo
fi

cd $ZERO_SDK_HOME


repo init -u https://github.com/zero-mcu/manifest.git \
          --repo-url=https://github.com/ArnoYuan/git-repo.git



