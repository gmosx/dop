#/usr/bin/sh

swift build -c release
rm /usr/local/bin/dop
ln -s `pwd`/.build/release/dop /usr/local/bin/dop
