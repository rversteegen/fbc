# include "fbcu.bi"

'' Currently, fbc processes escape codes differently when the source file
'' is ascii or unicode, so test escape codes here and the other variant files.

namespace fbc_tests.wstrings.utf8

#define hello "Καλημέρα "
#define world "κόσμε!"
#define helloworld hello + world

sub test_1 cdecl ()

	dim as wstring * 32 hw1 = "Καλημέρα κόσμε!"
	dim as wstring * 32 hw2 = helloworld

	CU_ASSERT( hw1 = hw2 )

	CU_ASSERT( hw1 = helloworld )

	CU_ASSERT( helloworld = hw2 )

	dim as wstring * 32 hello_escaped
	dim as string hello_escapedA

	hello_escapedA = !"\104\101\108\108\111"
	CU_ASSERT( hello_escapedA = "hello" )

	hello_escaped = !"\104\101\108\108\111"
	CU_ASSERT( hello_escaped = "hello" )
	hello_escaped = !"\x68\x65\x6C\x6C\x6F"
	CU_ASSERT( asc( hello_escaped, 2 ) = 101 )
	CU_ASSERT( hello_escaped = "hello" )
	hello_escaped = !"\&h68\&h65\&h6C\&h6C\&h6F"
	CU_ASSERT( hello_escaped = "hello" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 101 )
	hello_escaped = !"\u0068\u0065\u006C\u006C\u006F"
	CU_ASSERT( hello_escaped = "hello" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 101 )

	hello_escaped = !"\922\945\955\951\956\941\961\945\32"
	CU_ASSERT( hello_escaped = hello )
	CU_ASSERT( asc( hello_escaped, 2 ) = 945 )
	hello_escaped = !"\x039A\x03B1\x03BB\x03B7\x03BC\x03AD\x03C1\x03B1\x20"
	CU_ASSERT( hello_escaped = hello )
	CU_ASSERT( asc( hello_escaped, 2 ) = 945 )
	hello_escaped = !"\&h039A\&h03B1\&h03BB\&h03B7\&h03BC\&h03AD\&h03C1\&h03B1\&h20"
	CU_ASSERT( hello_escaped = hello )
	CU_ASSERT( asc( hello_escaped, 2 ) = 945 )
	hello_escaped = !"\u039A\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1\u0020"
	CU_ASSERT( hello_escaped = hello )
	CU_ASSERT( asc( hello_escaped, 2 ) = 945 )

	'' Escape codes above 0xffff not implemented yet
	'' (but if they are, these tests should pass even on a 1/2-byte-wstring
	'' host or target, because characters should always get down-converted
	'' in the same way)

	'' Hello in Etruscan
	hello_escaped = !"\66359\66352\66361\66363\66371"
	CU_ASSERT( hello_escaped = "𐌷𐌰𐌹𐌻𐍃" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 66352 )
	hello_escaped = !"\x10337\x10330\x10339\x1033B\x10343"
	CU_ASSERT( hello_escaped = "𐌷𐌰𐌹𐌻𐍃" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 66352 )
	hello_escaped = !"\&h10337\&h10330\&h10339\&h1033B\&h10343"
	CU_ASSERT( hello_escaped = "𐌷𐌰𐌹𐌻𐍃" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 66352 )
	hello_escaped = !"\u10337\u10330\u10339\u1033B\u10343"
	CU_ASSERT( hello_escaped = "𐌷𐌰𐌹𐌻𐍃" )
	CU_ASSERT( asc( hello_escaped, 2 ) = 66352 )

end sub

sub ctor () constructor

	fbcu.add_suite("fbc_tests.wstring.utf8")
	fbcu.add_test("test_1", @test_1)

end sub

end namespace
