#/usr/bin/sh

swift build -c release
ln -sf `pwd`/.build/release/dop /usr/local/bin/dop
