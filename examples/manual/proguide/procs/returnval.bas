'' examples/manual/proguide/procs/returnval.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: https://www.freebasic.net/wiki/wikka.php?wakka=ProPgReturnValue
'' --------

'' This program demonstrates a function returning a value.

Declare Function myFunction () As Integer

Dim a As Integer

'Here we take what myFunction returns and add 10.
a = myFunction() + 10

'knowing that myFunction returns 10, we get 10+10=20 and will print 20.
Print a 

Function myFunction () As Integer
  'Here we tell myFunction to return 10.
  Function = 10 
End Function
