%module fileNotify

%typemap(in) (char *str ) {
    $1 = StringValuePtr($input);
};

extern void watch( char *str, int watchType );

%include fileNotify.h
%{
    #include "fileNotify.h"
%}
