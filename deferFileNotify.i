%module deferFileNotify 


%{
    void wrap_defer(void *user_data)
        {
            VALUE proc = (VALUE)user_data;
            rb_funcall(proc, rb_intern("call"), 1);
        }
%}

%typemap(in) (callback_t callback, void *user_data)
{
    $1 = wrap_defer;
    $2 = (void *)$input;
}

%typemap(in) (char* path  ) {
    $1 = StringValuePtr($input);
};
%typemap(in) (char* nameFile  ) {
    $1 = StringValuePtr($input);
};


extern void watch( char* path, char* nameFile, int watchType );
%include deferFileNotify.h
%{
    #include "deferFileNotify.h"
%}
