## Instructions

For detailed engineering guidelines, please refer to [INSTRUCTIONS.md](INSTRUCTIONS.md).
# How Compiler
### Microsoft Visual Studio 2017 or higher for Windows
<details>
<summary>Windows/VCPKG Commands</summary>
  
```bash
git clone https://github.com/Microsoft/vcpkg
cd ./vcpkg
./bootstrap-vcpkg.bat
./vcpkg integrate install
./vcpkg install --triplet x64-windows boost-iostreams boost-asio boost-system boost-filesystem boost-variant boost-lockfree luajit libmariadb pugixml cryptopp fmt mpir
```
After go to folder open TibiaCore\compiler\vc17\theforgottenserver.vcxproj<br>
Wait for load all libs...<br>
And copiler project!
</details>

### GCC for Ubuntu 22.04
<details>
<summary>Ubuntu Commands</summary>
  
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git cmake build-essential libluajit-5.1-dev libmariadb-dev-compat libboost-date-time-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev libpugixml-dev libgmp3-dev libcrypto++-dev libfmt-dev libjsoncpp-dev
git clone https://github.com/RCP91/TibiaCore.git
cd TibiaCore/compiler
mkdir build && cd build
cmake ..
make
cd ../../ && cp -r compiler/build/tfs TibiaCore
ls
for run with screen and auto restart: screen ./restart.sh
or ./TibiaCore
```
### GCC Build Anti-RollBack for Ubuntu
<details>
<summary> Ubuntu Commands with gdb</summary>
  
```
sudo apt-get install gdb
cd compiler
mkdir build && cd build
cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo ..
make
```
</details>
</details>
<hr>
# Doar qualquer valor para Pix: +55 67 99941-1154<br>
# Donate any amount via PayPal: roberto.cpmg@gmail.com
