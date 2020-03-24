##  Nanobsd configuration scripts

Tested OK on FreeBSD 10.3, 11.1 and 12.0. If you're still use FreeBSD 9.x, replace 
```
NANO_BOOLOADER="boot/btx"
```
by
```
NANO_BOOLOADER="boot/boot0"
```
And remove ```cust_pkgng``` and ```cust_local``` functions in the configuration file.

## Installation instructions
On a FreeBSD system, as ```root``` or via ```sudo```:
```
mkdir spectro && cd spectro
git clone https://github.com/lhondareyte/spectro450-core.git
git clone https://github.com/lhondareyte/ports.git
cd spectr450
sudo make
sudo make diskimage
```
Building process may take some time (about 12 hours on a Intel CORE 2 from 2008).

