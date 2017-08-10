## Generic Nanobsd configuration

Tested OK on FreeBSD 10.3 and 11.3. For FreeBSD 9.x, replace 
```
NANO_BOOLOADER="boot/btx"
```
by
```
NANO_BOOLOADER="boot/boot0"
```
And remove cust_pkgng function.
