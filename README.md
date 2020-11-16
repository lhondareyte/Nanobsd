##  Nanobsd configuration scripts

Tested OK on FreeBSD 10.3, 11.1 and 12.0. If you're still use FreeBSD 9.x, replace 
``` NANO_BOOLOADER="boot/btx" ```
by
``` NANO_BOOLOADER="boot/boot0" ```
And remove ```cust_pkgng``` and ```cust_local``` functions in the configuration file.

## Creating a build environment
On a fresh installed FreeBSD machine (Latest supported release), as ```root``` or via ```sudo```:

### Installing dependencies
``` 
pkg install -y git \
               gmake \
               cmake \
               pkgconf \
               autotools \
               autoconf \
               sdcc
```
### Fetching repositories
```
cd 
mkdir spectro && cd spectro
B
git clone https://github.com/lhondareyte/Nanobsd.git spectro450
git clone https://github.com/lhondareyte/ports.git
cd /usr/ports/sysutils
ln -s $HOME/spectro/ports/spectro450
```
### Custom packages

#### DB5 database:
We need to replace stock db5 package (require by git and jack) by a custom strip down version
``` cd $HOME/spectro/ports/db5
pkg remove git
pkg autoremove -y      # remove git dependencies
make && make install   # Install strip down version
pkg lock -y db5
make install           # Build package for NanoBSD
```
#### Jack audio server
```
cd $HOME/spectro/ports
for d in libsamplerate jackit jack_umidi
do
    cd $d
    make package
    make install
    cd -
    pkg lock -y $d
done
```
### Building NanoBSD image
```
cd $HOME/spectro/spectro450
make 
make diskimage
make install
```
Building process may take some time (About 3 hours with a 4gen quad-core i5)

