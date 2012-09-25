'' misc helpers
''
''


#include once "fb.bi"
#include once "fbint.bi"
#include once "ir.bi"
#include once "lex.bi"
#include once "dstr.bi"

type FBHLPCTX
	profilecnt  as uinteger
end type


''globals
	dim shared ctx as FBHLPCTX

'':::::
sub hlpInit

	ctx.profilecnt = 0

end sub

'':::::
sub hlpEnd

end sub

'':::::
function hMatchText _
	( _
		byval txt as zstring ptr _
	) as integer

	if( ucase( *lexGetText( ) ) = *txt ) then
		lexSkipToken( )
		function = TRUE
	else
		function = FALSE
	end if

end function

'':::::
function hMatch _
	( _
		byval token as integer _
	) as integer

	if( lexGetToken( ) = token ) then
		lexSkipToken( )
		function = TRUE
	else
		function = FALSE
	end if

end function

'':::::
function hHexUInt _
	( _
		byval value as uinteger _
	) as zstring ptr static

    static as zstring * 8 + 1 res
    dim as zstring ptr p
    dim as integer lgt, maxlen

	static as integer hexTB(0 to 15) = _
	{ _
		asc( "0" ), asc( "1" ), asc( "2" ), asc( "3" ), _
		asc( "4" ), asc( "5" ), asc( "6" ), asc( "7" ), _
		asc( "8" ), asc( "9" ), asc( "A" ), asc( "B" ), _
		asc( "C" ), asc( "D" ), asc( "E" ), asc( "F" ) _
	}

	maxlen = 4
	if( value > 65535 ) then
		maxlen = 8
	end if

	p = @res + 8-1
	lgt = 0

	do
		*p = hexTB( value and &h0000000F )

		lgt +=1
		if( lgt = maxlen ) then
			exit do
		end if

		p -= 1
		value shr= 4
	loop

	function = p

end function

'':::::
function hMakeProfileLabelName _
	( _
	) as zstring ptr static

	static as zstring * 4 + 8 + 1 res

	res = "LP_" + *hHexUInt( ctx.profilecnt )

	ctx.profilecnt += 1

	function = @res

end function

'':::::
function hFloatToStr _
	( _
		byval value as double, _
		byref typ as integer _
	) as string static

    dim as integer expval

	'' x86 little-endian assumption
	expval = cast( integer ptr, @value )[1]

	select case expval
	'' -|+ infinite?
	case &h7FF00000UL, &hFFF00000UL
		if( typ = FB_DATATYPE_DOUBLE ) then
			typ = FB_DATATYPE_LONGINT
			if( expval and &h80000000 ) then
				function = "0xFFF0000000000000"
			else
				function = "0x7FF0000000000000"
			end if
		else
			typ = FB_DATATYPE_INTEGER
			if( expval and &h80000000 ) then
				function = "0xFF800000"
			else
				function = "0x7F800000"
			end if
		end if

	'' -|+ NaN? Quiet-NaN's only
	case &h7FF80000UL, &hFFF80000UL
		if( typ = FB_DATATYPE_DOUBLE ) then
			typ = FB_DATATYPE_LONGINT
			if( expval and &h80000000 ) then
				function = "0xFFF8000000000000"
			else
				function = "0x7FF8000000000000"
			end if
		else
			typ = FB_DATATYPE_INTEGER
			if( expval and &h80000000 ) then
				function = "0xFFC00000"
			else
				function = "0x7FC00000"
			end if
		end if

	case else
		function = str( value )
	end select

end function

'':::::
function hFBrelop2IRrelop _
	( _
		byval tk as integer _
	) as integer static

	dim as integer op = any

    select case as const tk
    case FB_TK_EQ
    	op = AST_OP_EQ
    case FB_TK_GT
    	op = AST_OP_GT
    case FB_TK_LT
    	op = AST_OP_LT
    case FB_TK_NE
    	op = AST_OP_NE
    case FB_TK_LE
    	op = AST_OP_LE
    case FB_TK_GE
    	op = AST_OP_GE
	case else
		errReport( FB_ERRMSG_EXPECTEDRELOP )
		'' error recovery: fake an op
		op = AST_OP_EQ
    end select

    function = op

end function

'':::::
function hFileExists _
	( _
		byval filename as zstring ptr _
	) as integer static
    dim f as integer

    f = freefile

	if( open( *filename, for input, as #f ) = 0 ) then
		function = TRUE
		close #f
	else
		function = FALSE
	end if

end function

'':::::
sub hUcase _
	( _
		byval src as const zstring ptr, _
		byval dst as zstring ptr _
	) static

    dim as integer c
    dim as const zstring ptr s
    dim as zstring ptr d

	s = src
	d = dst

	do
		c = *s
		if( c >= 97 ) then
			if( c <= 122 ) then
				c -= (97 - 65)
			end if
		elseif( c = 0 ) then
			exit do
		end if

		*d = c

		s += 1
		d += 1
	loop

	'' null-term
	*d = 0

end sub

'':::::
sub hClearName _
	( _
		byval src as zstring ptr _
	) static

    dim as zstring ptr p

	p = src

	do
		select case as const *p
		case 0
			exit do

		case CHAR_AUPP to CHAR_ZUPP, CHAR_ALOW to CHAR_ZLOW, CHAR_0 to CHAR_9, CHAR_UNDER

		case else
			*p = CHAR_ZLOW
		end select

		p += 1
	loop

end sub

'':::::
function hStripExt _
	( _
		byval filename as zstring ptr _
	) as string static

    dim as integer p, lp

	lp = 0
	do
		p = instr( lp+1, *filename, "." )
	    if( p = 0 ) then
	    	exit do
	    end if
	    lp = p
	loop

	if( lp > 0 ) then
		function = left( *filename, lp-1 )
	else
		function = *filename
	end if

end function

'':::::
function hStripPath _
	( _
		byval filename as zstring ptr _
	) as string static

    dim as integer lp, p_found, p(1 to 2)

	lp = 0
	do
		p(1) = instr( lp+1, *filename, RSLASH )
		p(2) = instr( lp+1, *filename, "/" )
        if p(1)=0 or (p(2)>0 and p(2)<p(1)) then
            p_found = p(2)
        else
            p_found = p(1)
        end if
	    if( p_found = 0 ) then
	    	exit do
	    end if
	    lp = p_found
	loop

	if( lp > 0 ) then
		function = mid( *filename, lp+1 )
	else
		function = *filename
	end if

end function

'':::::
function hStripFilename _
	( _
		byval filename as zstring ptr _
	) as string static

    dim as integer lp, p_found, p(1 to 2)

	lp = 0
	do
		p(1) = instr( lp+1, *filename, RSLASH )
		p(2) = instr( lp+1, *filename, "/" )
        if p(1)=0 or (p(2)>0 and p(2)<p(1)) then
            p_found = p(2)
        else
            p_found = p(1)
        end if
	    if( p_found = 0 ) then
	    	exit do
	    end if
	    lp = p_found
	loop

	if( lp > 0 ) then
		function = left( *filename, lp )
	else
		function = ""
	end if

end function

'':::::
function hGetFileExt _
	( _
		byval fname as zstring ptr _
	) as string static

    dim as integer p, lp
    dim as string res

	lp = 0
	do
		p = instr( lp+1, *fname, "." )
		if( p = 0 ) then
			exit do
		end if
		lp = p
	loop

    if( lp = 0 ) then
    	function = ""
    else
    	res = lcase( mid( *fname, lp+1 ) )
        if instr( res, RSLASH ) > 0 or instr( res, "/" ) > 0 then
            '' We had a folder with a "." inside ...
            function = ""
        elseif( len(res) > 0 ) then
	    	'' . or .. dirs?
	    	if( res[0] = asc( RSLASH ) or res[0] = asc( "/" ) ) then
	    		function = ""
	    	else
	    		function = res
	    	end if
        end if
    end if

end function

sub hReplaceSlash( byval s as zstring ptr, byval char as integer )
	for i as integer = 0 to len( *s ) - 1
		if( (s[i] = CHAR_RSLASH) or (s[i] = CHAR_SLASH) ) then
			s[i] = char
		end if
	next
end sub

function pathStripDiv( byref path as string ) as string
	dim as integer length = len( path )
	if( length > 0 ) then
		length -= 1
		select case( path[length] )
#if defined( __FB_WIN32__ ) or defined( __FB_DOS__ )
		case asc("/"), asc("\")
#else
		case asc("/")
#endif
			return left( path, length )
		end select
	end if
	function = path
end function

function pathIsAbsolute( byval path as zstring ptr ) as integer
#if defined( __FB_WIN32__ ) or defined( __FB_DOS__ )
	if( (*path)[0] <> 0 ) then
		select case( (*path)[1] )
		case asc( ":" )
			'' C:...
			function = TRUE
#ifdef __FB_WIN32__
		case asc( "\" )
			'' \\... UNC path
			function = ((*path)[0] = asc( "\" ))
#endif
		end select
	end if
#else
	'' /...
	function = ((*path)[0] = asc( "/" ))
#endif
end function

'':::::
function hToPow2 _
	( _
		byval value as uinteger _
	) as uinteger static

    dim n as uinteger

	static pow2tb(0 to 63) as uinteger = _
	{ _
		 0,  0,  0, 15,  0,  1, 28,  0, _
		16,  0,  0,  0,  2, 21, 29,  0, _
    	 0,  0, 19, 17, 10,  0, 12,  0, _
    	 0,  3,  0,  6,  0, 22, 30,  0, _
    	14,  0, 27,  0,  0,  0, 20,  0, _
    	18,  9, 11,  0,  5,  0,  0, 13, _
    	26,  0,  0,  8,  0,  4,  0, 25, _
    	 0,   7, 24,  0, 23,  0, 31,  0 _
	}

	'' don't check if it's zero
	if( value = 0 ) then
		return 0
	end if

	'' (n^(n-1)) * Harley's magic number
	n = ((value-1) xor value) * (7*255*255*255)

    '' extract bits <31:26>
    n = pow2tb(n shr 26)				'' translate into bit count - 1

    '' is this really a power of 2?
    if( value - (1 shl n) = 0 ) then
    	function = n
    else
    	function = 0
    end if

end function

'':::::
sub hConvertValue _
	( _
		byval src as FBVALUE ptr, _
		byval sdtype as integer, _
		byval dst as FBVALUE ptr, _
		byval ddtype as integer _
	) static

	select case as const sdtype
	case FB_DATATYPE_LONGINT, FB_DATATYPE_ULONGINT
conv_long:


	case FB_DATATYPE_SINGLE, FB_DATATYPE_DOUBLE
		select case as const ddtype
		case FB_DATATYPE_LONGINT, FB_DATATYPE_ULONGINT
			dst->long = src->float

		case FB_DATATYPE_SINGLE, FB_DATATYPE_DOUBLE
			dst->float = src->float

		case FB_DATATYPE_LONG, FB_DATATYPE_ULONG
			if( FB_LONGSIZE = len( integer ) ) then
				dst->int = src->float
			else
				dst->long = src->float
			end if

		case else
			dst->int = src->float
		end select

	case FB_DATATYPE_LONG, FB_DATATYPE_ULONG
		if( FB_LONGSIZE = len( integer ) ) then
			goto conv_int
		else
			goto conv_long
		end if

	case else
conv_int:

		select case as const ddtype
		case FB_DATATYPE_LONGINT, FB_DATATYPE_ULONGINT
			dst->long = src->int

		case FB_DATATYPE_SINGLE, FB_DATATYPE_DOUBLE
			dst->float = src->int

		case FB_DATATYPE_LONG, FB_DATATYPE_ULONG
			if( FB_LONGSIZE = len( integer ) ) then
				dst->int = src->int
			else
				dst->long = src->int
			end if

		case else
			dst->int = src->int
		end select
	end select

end sub

'':::::
function hJumpTbAllocSym _
	( _
		_
	) as any ptr

	dim as zstring * FB_MAXNAMELEN+1 sname = any
	static as FBARRAYDIM dTB(0)
	dim as FBSYMBOL ptr s = any

	sname = *hMakeTmpStr( )

	s = symbAddVarEx( @sname, NULL, _
					  typeAddrOf( FB_DATATYPE_VOID ), NULL, _
					  FB_POINTERSIZE, _
					  1, dTB(), _
					  FB_SYMBATTRIB_SHARED )

	symbSetIsJumpTb( s )

	symbSetIsInitialized( s )

	function = s

end function

'':::::
function hCheckFileFormat _
	( _
		byval f as integer _
	) as integer

    dim as integer BOM
    dim as FBFILE_FORMAT fmt

	'' little-endian assumptions
	fmt = FBFILE_FORMAT_ASCII

	if( get( #f, 0, BOM ) = 0 ) then
		if( BOM = &hFFFE0000 ) then
			fmt = FBFILE_FORMAT_UTF32BE

		elseif( BOM = &h0000FEFF ) then
		    fmt = FBFILE_FORMAT_UTF32LE

		else
			BOM and= &h00FFFFFF
			if( BOM = &h00BFBBEF ) then
				fmt = FBFILE_FORMAT_UTF8

			else
				BOM and= &h0000FFFF
		        if( BOM = &h0000FEFF ) then
		        	fmt = FBFILE_FORMAT_UTF16LE

		        elseif( BOM = &h0000FFFE ) then
		        	fmt = FBFILE_FORMAT_UTF16BE
		        end if
			end if
		end if

		select case fmt
		case FBFILE_FORMAT_ASCII
			seek #f, 1

		case FBFILE_FORMAT_UTF8
			seek #f, 1+3

		case FBFILE_FORMAT_UTF16LE, _
			 FBFILE_FORMAT_UTF16BE
			seek #f, 1+2
		end select
	end if

	function = fmt

end function

function hCurDir( ) as string
	'' curdir() usually won't be terminated with a path separator,
	'' except when it points to the file system root, instead of
	'' some directory (e.g. C:\ on Win32 or / on Unix).
	function = pathStripDiv( curdir( ) )
end function

function hIsValidSymbolName( byval sym as zstring ptr ) as integer

	if( sym = NULL ) then exit function

	var symlen = len( *sym )

	if( symlen = 0 ) then exit function

	if( (hIsChar(sym[0]) orelse (sym[0] = asc("_"))) = FALSE ) then exit function

	for i as integer = 1 to symlen-1
		if( ((hIsChar(sym[i])) orelse (sym[i] = asc("_")) orelse (hIsCharNumeric(sym[i]))) = FALSE ) then exit function
	next

	function = TRUE

end function

'' Checks whether a string starts with and ends in [double-]quotes.
private function strIsQuoted(byref s as string) as integer
	dim as integer last = len(s) - 1
	if (last < 1) then
		return FALSE
	end if

	return (((s[0] = asc("""")) and (s[last] = asc(""""))) or _
	        ((s[0] = asc("'" )) and (s[last] = asc("'" ))))
end function

function strUnquote(byref s as string) as string
	if (strIsQuoted(s)) then
		return mid(s, 2, len(s) - 2)
	end if
	return s
end function

