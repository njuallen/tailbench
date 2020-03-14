export CXXFLAGS="-std=c++98"
./bootstrap
./configure --enable-dora --enable-dbgsymbols
make -j32
