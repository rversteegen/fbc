''
''
'' io -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __crt_io_bi__
#define __crt_io_bi__

#include once "crt/long.bi"
#include once "crt/stdio.bi"
#include once "crt/stdint.bi"
#include once "crt/sys/types.bi"

#if defined(__FB_WIN32__)

#define _A_NORMAL &h00000000
#define _A_RDONLY &h00000001
#define _A_HIDDEN &h00000002
#define _A_SYSTEM &h00000004
#define _A_VOLID &h00000008
#define _A_SUBDIR &h00000010
#define _A_ARCH &h00000020

#ifndef _fsize_t
type _fsize_t as ulong
#endif

type _finddata_t
	attrib as uinteger
	time_create as time_t
	time_access as time_t
	time_write as time_t
	size as _fsize_t
	name as zstring * (260)
end type

type _finddatai64_t
	attrib as uinteger
	time_create as time_t
	time_access as time_t
	time_write as time_t
	size as longint
	name as zstring * (260)
end type

#define HANDLE_MAX (20)
#define F_OK 0
#define X_OK 1
#define W_OK 2
#define R_OK 4


extern "c"
declare function _findfirst (byval as zstring ptr, byval as _finddata_t ptr) as intptr_t
declare function _findnext (byval as intptr_t, byval as _finddata_t ptr) as long
declare function _findclose (byval as intptr_t) as long
declare function _chdir (byval as zstring ptr) as long
declare function _getcwd (byval as zstring ptr, byval as long) as zstring ptr
declare function _mkdir (byval as zstring ptr) as long
declare function _mktemp (byval as zstring ptr) as zstring ptr
declare function _rmdir (byval as zstring ptr) as long
declare function _chmod (byval as zstring ptr, byval as long) as long
declare function _filelengthi64 (byval as long) as longint
declare function _findfirsti64 (byval as zstring ptr, byval as _finddatai64_t ptr) as intptr_t
declare function _findnexti64 (byval as intptr_t, byval as _finddatai64_t ptr) as long
declare function _lseeki64 (byval as long, byval as longint, byval as long) as longint
declare function _telli64 (byval as long) as longint
declare function _access (byval as zstring ptr, byval as long) as long
declare function _chsize (byval as long, byval as clong) as long
declare function _close (byval as long) as long
declare function _commit (byval as long) as long
declare function _creat (byval as zstring ptr, byval as long) as long
declare function _dup (byval as long) as long
declare function _dup2 (byval as long, byval as long) as long
declare function _filelength (byval as long) as clong
declare function _get_osfhandle (byval as long) as intptr_t
declare function _isatty (byval as long) as long
declare function _eof (byval as long) as long
declare function _locking (byval as long, byval as long, byval as clong) as long
declare function _lseek (byval as long, byval as clong, byval as long) as clong
declare function _open (byval as zstring ptr, byval as long, ...) as long
declare function _open_osfhandle (byval as intptr_t, byval as long) as long
declare function _pipe (byval as long ptr, byval as ulong, byval as long) as long
declare function _read (byval as long, byval as any ptr, byval as ulong) as long
declare function _setmode (byval as long, byval as long) as long
declare function _sopen (byval as zstring ptr, byval as long, byval as long, ...) as long
declare function _tell (byval as long) as clong
declare function _umask (byval as long) as long
declare function _unlink (byval as zstring ptr) as long
declare function _write (byval as long, byval as any ptr, byval as ulong) as long
end extern

/'


' Microsoft renamed all POSIX but non-standard C functions to have a leading underscore
' However, many of this functions don't exist in POSIX, or have a different name.
' Those that exist in POSIX are aliased to their POSIX names here, for code portability.

'#define findfirst _findfirst
'#define findnext _findnext
'#define findclose _findclose
#define chdir_ _chdir
#define getcwd _getcwd
#define mkdir_ _mkdir
#define mktemp _mktemp
#define rmdir_ _rmdir
#define chmod _chmod
'#define filelengthi64 _filelengthi64
'#define findfirsti64 _findfirsti64
'#define findnexti64 _findnexti64
'#define lseeki64 _lseeki64
'#define telli64 _telli64
#define access _access
'#define chsize _chsize
#define close_ _close
'#define commit _commit
#define creat _creat
#define dup _dup
#define dup2 _dup2
'#define filelength _filelength
'#define get _get
#define isatty _isatty
'#define eof _eof
'#define locking _locking
#define lseek _lseek
#define open_ _open
#define pipe _pipe
#define read_ _read
'#define setmode _setmode
'#define sopen _sopen
'#define tell _tell
#define umask _umask
#define unlink _unlink
#define write _write

'/


#elseif defined(__FB_LINUX__)


/'

'The rtlib declares _FILE_OFFSET_BITS as 64.
'Therefore for consistency we provide 64 bit versions of all IO functions.
'Non-64bit versions are legacy and not provided here.

type off64_t as longint
type off_t as off64_t

' From fcntl.h

#define F_OK 0
#define X_OK 1
#define W_OK 2
#define R_OK 4

declare function fcntl(byval __fd as long, byval __cmd as long, ...) as long
#define _open open64
declare function open64(byval __file as const zstring ptr, byval __oflag as long, ...) as long
#define openat openat64
declare function openat64(byval __fd as long, byval __file as const zstring ptr, byval __oflag as long, ...) as long
#define creat creat64
declare function creat64(byval __file as const zstring ptr, byval __mode as mode_t) as long
const F_ULOCK = 0
const F_LOCK = 1
const F_TLOCK = 2
const F_TEST = 3
#define lockf lockf64
declare function lockf64(byval __fd as long, byval __cmd as long, byval __len as off64_t) as long
#define posix_fadvise posix_fadvise64
declare function posix_fadvise64(byval __fd as long, byval __offset as off64_t, byval __len as off64_t, byval __advise as long) as long
#define posix_fallocate posix_fallocate64


' Part of unistd.h

#define lseek lseek64
declare function lseek64(byval __fd as long, byval __offset as __off64_t, byval __whence as long) as __off64_t
declare function _close alias "close"(byval __fd as long) as long
declare function _read alias "read"(byval __fd as long, byval __buf as any ptr, byval __nbytes as uinteger) as integer
declare function write(byval __fd as long, byval __buf as const any ptr, byval __n as uinteger) as integer
#define pread pread64
#define pwrite pwrite64
declare function pread64(byval __fd as long, byval __buf as any ptr, byval __nbytes as uinteger, byval __offset as __off64_t) as integer
declare function pwrite64(byval __fd as long, byval __buf as const any ptr, byval __n as uinteger, byval __offset as __off64_t) as integer
declare function pipe(byval __pipedes as long ptr) as long
declare function pipe2(byval __pipedes as long ptr, byval __flags as long) as long
declare function chown(byval __file as const zstring ptr, byval __owner as __uid_t, byval __group as __gid_t) as long
declare function fchown(byval __fd as long, byval __owner as __uid_t, byval __group as __gid_t) as long
declare function lchown(byval __file as const zstring ptr, byval __owner as __uid_t, byval __group as __gid_t) as long
declare function fchownat(byval __fd as long, byval __file as const zstring ptr, byval __owner as __uid_t, byval __group as __gid_t, byval __flag as long) as long
declare function _chdir alias "chdir"(byval __path as const zstring ptr) as long
declare function fchdir(byval __fd as long) as long
declare function getcwd(byval __buf as zstring ptr, byval __size as uinteger) as zstring ptr
declare function get_current_dir_name() as zstring ptr
declare function getwd(byval __buf as zstring ptr) as zstring ptr
declare function dup(byval __fd as long) as long
declare function dup2(byval __fd as long, byval __fd2 as long) as long
declare function dup3(byval __fd as long, byval __fd2 as long, byval __flags as long) as long


declare function ttyname(byval __fd as long) as zstring ptr
declare function ttyname_r(byval __fd as long, byval __buf as zstring ptr, byval __buflen as uinteger) as long
declare function isatty(byval __fd as long) as long
declare function ttyslot() as long
declare function link(byval __from as const zstring ptr, byval __to as const zstring ptr) as long
declare function linkat(byval __fromfd as long, byval __from as const zstring ptr, byval __tofd as long, byval __to as const zstring ptr, byval __flags as long) as long
declare function symlink(byval __from as const zstring ptr, byval __to as const zstring ptr) as long
declare function readlink(byval __path as const zstring ptr, byval __buf as zstring ptr, byval __len as uinteger) as integer
declare function symlinkat(byval __from as const zstring ptr, byval __tofd as long, byval __to as const zstring ptr) as long
declare function readlinkat(byval __fd as long, byval __path as const zstring ptr, byval __buf as zstring ptr, byval __len as uinteger) as integer
declare function unlink(byval __name as const zstring ptr) as long
declare function unlinkat(byval __fd as long, byval __name as const zstring ptr, byval __flag as long) as long
declare function _rmdir alias "rmdir"(byval __path as const zstring ptr) as long

declare function fsync(byval __fd as long) as long
declare function syncfs(byval __fd as long) as long
declare sub sync()

'' TODO: extern int truncate (const char *__file, __off64_t __length) __asm__ ("" "") __attribute__ ((__nothrow__));
declare function truncate64(byval __file as const zstring ptr, byval __length as __off64_t) as long
'' TODO: extern int ftruncate (int __fd, __off64_t __length) __asm__ ("" "") __attribute__ ((__nothrow__));
declare function ftruncate64(byval __fd as long, byval __length as __off64_t) as long
declare function fdatasync(byval __fildes as long) as long

'/


#else
# error Unsupported platform
#endif

#endif
