'' examples/manual/console/input2.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: https://www.freebasic.net/wiki/wikka.php?wakka=KeyPgInput
'' --------

Dim As Double a, b
Dim As String yn

Do
	
	Input   "Please enter a number: ", a
	Input ; "And another: ", b
	Print , "Thank you"
	Sleep 500
	Print
	Print "The total is "; a + b
	Print
	
	Do
		Input "Would you like to enter some more numbers"; yn
		yn = LCase(yn)
	Loop Until yn = "y" Or yn = "n"
	
Loop While LCase(yn) = "y"
