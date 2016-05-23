module test05;

var i, j, k : integer;
		b, c : boolean;
		A : integer[5];
		B : boolean[5];
		C : integer[5][5];
		D : boolean[5][5];
		E : integer[5];
		F : integer[5][5][5];

function foo (G, H : integer[5][5]) : boolean;
begin
	//H := G;
	H[1][2] := G[2][3];
	return true
end foo;

begin
	F[1][2][3] := i
	//A[3] := i
	//foo(A, E)
	//F[1][2] := A
	//A[2] := i + j
	//C[2][3] := A[3];
	//D[2][3] := !b && c
end test05.
