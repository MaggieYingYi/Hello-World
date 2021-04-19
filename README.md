# Hello-World

Build and run Hello World in C with a repo-based musl-libc library.

## Build musl-libc with the Program Repository Compiler

Create the [llvm-prepo container](https://hub.docker.com/r/paulhuggett/llvm-prepo) via:
```
docker pull paulhuggett/llvm-prepo:latest
docker run --rm --tty --interactive paulhuggett/llvm-prepo:latest
```
Use the following series of commands to install various third-party tools on which the build depends.
```
sudo apt-get update
sudo apt-get install --no-install-recommends -y ca-certificates git python make
```
Clone the musl-prepo project via:
```
cd ~
git clone --depth=1 https://github.com/MaggieYingYi/musl-prepo.git
```
Configure via:
```
cd musl-prepo
./configure --disable-shared --prefix=~/musl
```
Perform the build of musl-prepo.
```
make
```

Install the musl-prepo.
```
make install
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
