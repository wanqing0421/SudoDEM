#!/bin/bash

#install the 3rd-party libraries for SudoDEM
cd ..
mkdir 3rdlib
cd 3rdlib
mkdir -p 3rdlibs/py
mkdir HeaderLib
#Install on Ubuntu
WORKSPACE=$PWD
#1. Basic dependencies
sudo apt install build-essential cmake freeglut3-dev zlib1g-dev python-dev qt4-default libbz2-dev libxi-dev libglib2.0-dev libxmu-dev

#2. Python modules
sudo apt install python-numpy python-tk python-xlib python-qt4 
#we need ipython with version 3.0. 'apt install' will install a version 5.0 that is not compatible with SudoDEM at present. We may fix it in the future. As a workaround, we just copy a pakcage of v3.0 to the library path '3rdlibs/py/'.

#3. Boost
wget https://www.sudosimlab.com/downloadData/3rdlibs/boost_1_67_0.tar.gz
tar xzf boost_1_67_0.tar.gz
cd boost_1_67_0
./bootstrap.sh  --with-libraries=python,thread,filesystem,iostreams,regex,serialization,system,date_time link=shared runtime-link=shared --without-icu 
./b2 −j3 #compile with 3 threads
#./b2
./b2 install --prefix=$PWD/../HeaderLib

#4. Minieigen
#get the eigen source first
cd $WORKSPACE
#wget http://bitbucket.org/eigen/eigen/get/3.3.5.tar.bz2 #this link was broken
#tar xf 3.3.5.tar.bz2
#mv eigen-eigen-b3f3d4950030 Eigen-3.3.5
wget https://www.sudosimlab.com/downloadData/3rdlibs/eigen-3.3.5.tar.gz
tar xzf eigen-3.3.5.tar.gz
mv eigen-git-mirror-3.3.5 Eigen-3.3.5
cp -rf Eigen-3.3.5 HeaderLib/
#get the minieigen source
wget https://www.sudosimlab.com/downloadData/3rdlibs/minieigen-1.0.tar.gz
tar xzf minieigen-1.0.tar.gz 
cd minieigen-minieigen-1.0
mkdir build
cd build 
cmake .. -DCMAKE_INSTALL_PREFIX=../../HeaderLib/lib/py
make
make install

#5. LibQGLViewer-2.6.3
cd $WORKSPACE
wget https://www.sudosimlab.com/downloadData/3rdlibs/libQGLViewer-2.6.3.tar.gz
tar xzf libQGLViewer-2.6.3.tar.gz
cd libQGLViewer-2.6.3-2.6.3/QGLViewer
qmake 
make
make install
#cp all dynamic libraries into a folder '3rdlibs'.
cd $WORKSPACE
cp -rf HeaderLib/lib/*.so* 3rdlibs/
cp HeaderLib/lib/py/lib/minieigen.so 3rdlibs/py/minieigen.so

#IPython 3.0
wget https://www.sudosimlab.com/downloadData/3rdlibs/IPython-3.0.tar.gz
tar xzf IPython-3.0.tar.gz
cp -rf IPython-3.0 3rdlibs/py/IPython
