swig -ruby defer.i
gcc -shared -o defer.so defer.c defer_wrap.c -I/opt/rh/ruby193/root/usr/include/ -I/opt/rh/ruby193/root/usr/include/x86_64-linux/ -fPIC

swig -ruby fileNotify.i
gcc -shared -o fileNotify.so fileNotify.c fileNotify_wrap.c -I/opt/rh/ruby193/root/usr/include/ -I/opt/rh/ruby193/root/usr/include/x86_64-linux/ -fPIC
