swig -ruby deferFileNotify.i
gcc -shared -o deferFileNotify.so deferFileNotify.c deferFileNotify_wrap.c -I/opt/rh/ruby193/root/usr/include/ -I/opt/rh/ruby193/root/usr/include/x86_64-linux/ -fPIC

