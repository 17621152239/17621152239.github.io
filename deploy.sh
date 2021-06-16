#!/bin/sh

Usage() {
    echo "welcome use front-end release script
    -----------------------------------------
    use it require input your deploy target
           gook luck!
    -----------------------------------------
    Usage:

    # 发布github.io
    ./deploy.sh github.io
    "
}

die() {
    echo
    echo "$*"
    Usage
    echo
    exit 1
}

# get real path
abspath=$(pwd)

#清除之前生成的文件
rm -rf $abspath/_book

TARGET=$1
PROJECT='my town'

sync() {
    case $* in
    "github.io")
        echo "sync $PROJECT gitbook website to $TARGET"
        GITHUB_PROJECT_PATH="/d/share/17621152239/17621152239.github.io"
        echo 'tar -cpzf data.src.tar.gz _book/*'
        cd _book
        tar -cpzf ../data.src.tar.gz *
        cd ..
        echo "cp data.src.tar.gz ${GITHUB_PROJECT_PATH}"
        cp data.src.tar.gz $GITHUB_PROJECT_PATH

        cd $GITHUB_PROJECT_PATH
        tar -xzvf data.src.tar.gz
        rm -rf data.src.tar.gz
        git status
        git commit -am "deploy from gitbook"
        git push origin master
        ;;
    esac
}

build() {

    echo "build $PROJECT document"

    deploy="./deploy"

    gitbook init

    rm -rf _book

    gitbook build
}

blog() {
    echo "build & sync $PROJECT to github.io"
    build
    sync $TARGET
}

# 判断执行参数，调用指定方法
case $TARGET in
github.io)
    blog
    ;;
*)
    die "parameters is no reght!"
    ;;
esac
