##  Nanobsd configuration scripts

Tested OK on FreeBSD 10.3, 11.1 and 12.0. If you're still use FreeBSD 9.x, replace 
``` NANO_BOOLOADER="boot/btx" ```
by
``` NANO_BOOLOADER="boot/boot0" ```
And remove ```cust_pkgng``` and ```cust_local``` functions in the configuration file.

## Installation
On a fresh installed FreeBSD12 system, as ```root``` or via ```sudo```:

### Dependencies installation
``` pkg install -y git gmake pkgconf autotools autoconf sdcc ```

### Fetching repositories
``` cd /
mkdir spectro && cd spectro
git clone https://github.com/lhondareyte/spectro450.git
git clone https://github.com/lhondareyte/ports.git ```
### Custom packages installation
#### DB5 database:
We need to replace stock db5 package (require by git) by a custom strip down version
``` cd /spectro/ports/db5
make package
pkg remove git
pkg autoremove -y # remove git dependencies
make install 
pkg lock -y db5
pkg install -y db5 ```
#### Jack audio server
``` cd /spectro/ports
for i in libsamplerate jackit
do
    cd $i
    make package
    make install
    cd -
    pkg lock -y $i
done ```
Building process may take some time.

