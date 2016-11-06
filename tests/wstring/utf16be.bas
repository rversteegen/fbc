# include "fbcu.bi"

namespace fbc_tests.wstrings.utf16be

#define hello "Καλημέρα "
#define world "κόσμε!"
#define helloworld hello + world

sub test_1 cdecl ()

	dim as wstring * 32 hw1 = "Καλημέρα κόσμε!"
	dim as wstring * 32 hw2 = helloworld

	assert( hw1 = hw2 )

	assert( hw1 = helloworld )

	assert( helloworld = hw2 )

end sub

sub ctor () constructor

	fbcu.add_suite("fbc_tests.wstring.utf16be")
	fbcu.add_test("test_1", @test_1)

end sub

end namespace
