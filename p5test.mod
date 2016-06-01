module hello;

var i, j : integer;
		b : boolean;
		c : char;
		arr0 : integer[5];

function foo (i1 : integer) : integer;
var a : integer;
		z : integer;
		c1 : char;
		b1 : boolean;
begin
	b := true && false;
	b := true || false;
	if ('a' = 'z') then
		i1 := 1
	else
		i1 := 2
	end
end foo;

procedure bar (i2 : integer; ia : integer[5]);
var arr : integer[5];
begin
end bar;

begin
	i := j + 1;
	foo(i);
	foo(1);
	bar(j, arr0);
	bar(2, arr0)
end hello.
