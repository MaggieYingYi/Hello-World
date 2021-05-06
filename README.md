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
sudo apt-get install --no-install-recommends -y ca-certificates git python
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
## Build LLVM runtime libraries using the built musl-prepo libc libraries.

Clone the llvm-project-prepo project via:
```
cd  ~
git clone --depth=1  https://github.com/SNSystems/llvm-project-prepo.git
```
Clone the pstore project via:
```
cd llvm-project-prepo
git clone --depth=1 https://github.com/SNSystems/pstore.git
```
Configure and build clang/LLVM. llvm-config is required when build the compiler-rt library and clang include headers are required when build the libcxxabi library:
```
mkdir build && cd build
cmake -D CMAKE_BUILD_TYPE=Release \
      -D LLVM_ENABLE_PROJECTS="clang;pstore" \
      -D LLVM_TARGETS_TO_BUILD=X86 \
      -D LLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=Off \
      ../llvm
make -j 8
```
Build LLVM runtime libraries via:
```
cd  ~/llvm-project-prepo/llvm/utils/repo
make all
```
## Build Helloc World with the Program Repository Compiler and musl-libc

Clone the Hello-World project via:
```
cd ~
git clone --depth=1 https://github.com/MaggieYingYi/Hello-World.git
```
Build and run hello world C/C++ code.
```
cd Hello-World
make all
./helloc
./hellocpp
```
