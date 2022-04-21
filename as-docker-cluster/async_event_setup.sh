wget -q https://github.com/libuv/libuv/archive/v1.8.0.tar.gz
tar xzf v1.8.0.tar.gz
cd libuv-1.8.0
sh autogen.sh
./configure
make
make install
export LD_LIBRARY_PATH=/usr/local/lib

wget -q http://dist.schmorp.de/libev/Attic/libev-4.24.tar.gz
tar xzf libev-4.24.tar.gz
cd libev-4.24
sh autogen.sh
./configure
make
make install
export LD_LIBRARY_PATH=/usr/local/lib

wget -q https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
tar xzf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
sh autogen.sh
./configure
make
make install
export LD_LIBRARY_PATH=/usr/local/lib
