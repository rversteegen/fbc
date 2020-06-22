'' examples/manual/proguide/references/with-pointer2.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: https://www.freebasic.net/wiki/wikka.php?wakka=ProPgReferences
'' --------

Type myBase Extends Object
	Declare Virtual Function clone () As myBase Ptr
	Declare Virtual Sub Destroy ()
End Type

Function myBase.clone () As myBase Ptr
	Dim As myBase Ptr pp = New myBase(This)
	Print "myBase.clone() As myBase Ptr", pp
	Function = pp
End Function

Sub myBase.Destroy ()
	Print "myBase.Destroy()", , @This
	Delete @This
End Sub


Type myDerived Extends myBase
	Declare Function clone () As myDerived Ptr Override  '' overriding member function with covariant return
	Declare Sub Destroy () Override                      '' overriding member subroutine
End Type

Function myDerived.clone () As myDerived Ptr      '' overriding member function with covariant return
	Dim As myDerived Ptr pc = New myDerived(This)
	Print "myDerived.clone() As myDerived Ptr", pc
	Function = pc
End Function

Sub myDerived.Destroy ()                '' overriding member subroutine
	Print "myDerived.Destroy()", , @This
	Delete @This
End Sub


Dim As myDerived c

Dim As myBase Ptr ppc = @c                '' base type pointer to derived object c
Dim As myDerived Ptr pcc = @c             '' derived type pointer to derived object c

Dim As myBase Ptr ppc1 = ppc->clone()     '' base type pointer to clone of object c
'                                              (through its base type pointer and polymorphism)
Dim As myDerived Ptr pcc1 = pcc->clone()  '' derived type pointer to derived object c
'                                              (through its derived type pointer and covariance of return value)
Print
ppc1->Destroy()                           '' using base type pointer and polymorphism
pcc1->Destroy()                           '' using derived type pointer

Sleep
			
