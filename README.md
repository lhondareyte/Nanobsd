##  Nanobsd configuration scripts

Tested OK on FreeBSD 10.3 and 11.1. If you're still use FreeBSD 9.x, replace 
```
NANO_BOOLOADER="boot/btx"
```
by
```
NANO_BOOLOADER="boot/boot0"
```
And remove cust_pkgng/cust_local functions in configuration file.
