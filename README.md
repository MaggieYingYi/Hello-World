# Hello-World

Build and run Hello World in C with a repo-based musl-libc library.

## Build musl-libc with the Program Repository Compiler

First create the [llvm-prepo container](https://hub.docker.com/r/paulhuggett/llvm-prepo), then use the following series of commands to install various third-party tools on which the build depends.
```
sudo apt-get update
sudo apt-get install -y git python cmake ninja-build
```
Clone the musl-prepo project via:
```
cd ~
git clone --depth=1 https://github.com/MaggieYingYi/musl-prepo.git
```
Then configure via:
```
cd musl-prepo
CC=clang ./configure --disable-shared --prefix=<install dir>
```
Finally perform the build of musl-prepo.
```
make
```

## Build Helloc World with the Program Repository Compiler and musl-libc

Clone the musl-prepo project via:
```
cd ~
git clone --depth=1 https://github.com/MaggieYingYi/Hello-World.git
```
Build and run hello world C code.
```
cd Hello-World
make
./helloc
```
