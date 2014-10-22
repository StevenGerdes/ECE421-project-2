%module defer

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

%include defer.h
%{
    #include "defer.h"
%}
