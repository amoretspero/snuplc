module test05;

var i, j, k : integer;
		b, c : boolean;
		A : integer[5];
		B : boolean[5];
		C : integer[5][5];
		C1 : integer[5][5];
		D : boolean[5][5];
		E : integer[5];
		F : integer[5][5][5];

function foo (G, H : integer[5][5]) : boolean;
begin
	H := G;
	H[1][2] := G[2][3];
	return true
end foo;

function bar (I, J : boolean [5][5]) : boolean;
begin
	I := J;
	I[1][2] := J[2][3];
	return false
end bar;

function foobar (I, J : integer[5]) : boolean;
begin
	I[1] := J[2];
	return false
end foobar;

function simple (A : integer[5]) : boolean;
begin
	A[1] := 2;
	return true
end simple;

function fun (a : integer) : boolean;
begin
	return true
end fun;

begin
	F[1][2][3] := i;
	b := fun(C[1][2]);
	b := simple(C[1]);
	b := simple(C[1]) && simple(C[2]);
	b := B[1] && B[2];
	WriteStr("Hello, World!")
	//b := foo(C, C1);
	//b := foobar(C[1], C1[2])
	//A[3] := i
	//foo(A, E)
	//F[1][2] := A
	//A[2] := i + j
	//C[2][3] := A[3];
	//D[2][3] := !b && c
end test05.
