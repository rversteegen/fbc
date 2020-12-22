'' examples/manual/proguide/recursion_iteration/translation_to_iterative_reverse.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: https://www.freebasic.net/wiki/wikka.php?wakka=ProPgRecursionIteration
'' --------

Function translationToIterativeReverse (ByVal s As String, ByVal cumul As String = "") As String
	begin:
	If (s = "") Then                '' end condition
		Return cumul
	Else                            '' iteration loop
		cumul = Left(s, 1) & cumul  '' iterative accumulation
		s = Mid(s, 2)
		Goto begin                  '' iterative jump
	End If
End Function
		
