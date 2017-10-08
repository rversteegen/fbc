''
''
'' stdlib -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __crt_linux_stdlib_bi__
#define __crt_linux_stdlib_bi__

#define RAND_MAX &h7FFFFFFF
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

extern "c"
declare function mkstemp (byval template_ as zstring ptr) as long
end extern

#endif '' __crt_linux_stdlib_bi__
