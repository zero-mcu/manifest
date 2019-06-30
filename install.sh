#!/bin/sh

PROJECT_PATH=~/Development/workspace
ZERO_SDK_NAME=zero-mcu
ZERO_SDK_HOME=$PROJECT_PATH/$ZERO_SDK_NAME
BACKUP_PATH=~/bakcup
BASHRC_PATH=~/
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

echo "install zero-mcu version: $VERSION ..."

SyncRepo()
{
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

    repo sync
}

SyncRepo

GenerateEnv()
{
    if [ -f $BACKUP_PATH/.bashrc ]; then
        echo "Environment variable has already been generated, Please check /etc/profile.bak\
        or $BACKUP_PATH/.bashrc.bak, maybe has exist!"
        exit 1
    else
        if [ ! -d $BACKUP_PATH ]; then
            mkdir -p $BACKUP_PATH
        fi
        cp $BASHRC_PATH/.bashrc $BACKUP_PATH/ >/dev/null 2>&1
        mv $BASHRC_PATH/.bashrc $BASHRC_PATH/.bashrc.bak > /dev/null 2>&1

        sed -i 's/export ZERO_SDK_HOME=.*//g' $BACKUP_PATH/.bashrc
        # remove last '\n'
        line=`sed -n '$=' $BACKUP_PATH/.bashrc`
        line=`expr $line - 1`
        sed -i $line'{N;s/^\n//}' $BACKUP_PATH/.bashrc
        line=`sed -n '$=' $BACKUP_PATH/.bashrc`
        line=`expr $line - 1`
        sed -i $line'{N;s/^\n//}' $BACKUP_PATH/.bashrc

        echo >>$BACKUP_PATH/.bashrc
        echo "export ZERO_SDK_HOME=$ZERO_SDK_HOME/" >> $BACKUP_PATH/.bashrc
        echo >>$BACKUP_PATH/.bashrc
        mv $BACKUP_PATH/.bashrc $BASHRC_PATH/
    fi
}

GenerateEnv

