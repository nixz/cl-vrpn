# cl-vrpn
VRPN bindings for CommonLisp. At this time we are only going to use a limited
feature of VRPN i.e simply a client.

Requirements
================
1. CMake
2. VRPN
3. Linux

note : We need VRPN built and installed in a certain directory. We have only
tested this on linux so far. 

Usage
=======

1. Download the source

# git clone git@github.com:nixz/cl-vrpn.git

2. Get into the downloaded directory

# cd cl-vrpn

3. Make a build directory

# mkdir build

4. Get into the build directory

# cd build

5. Configure using cmake

# cmake-gui ../

or

# ccmake ../

6. Make sure the VRPN include paths and library paths are set for successful
   configuration. Once this is done the next step will be to build. Depending
   on the build system you chose use if to build the code
   
# ninja 

or 

# make

7. This builds the wrapper library libcl-vrpn.so. Copy the library the source
   directory
   
# cp libcl-vrpn.so ../

8. Copy the entire directory or link the the directory to quicklisp's local
   projects directory
   
# cd /path/to/quicklisp/local-projects
# ln -s /path/to/cl-vrpn .

9. In Emacs or wherever you are running common lisp load the library

> (ql:quickload :cl-vrpn)



