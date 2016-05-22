module test04;

var i, j, k : integer;
		b, c : boolean;

procedure foo(a : integer);
var p1 : integer;
begin
  a := i;
	a := a + 1;
	return
end foo;

function bar(d : boolean) : boolean;
begin
  if (d) then
		b := c
	else
		b := !c
	end;
	i := j + k;
	//return d
	return (!d && c)
end bar;

begin
  i := 1;
  foo(3);
	foo(k);
	b := !c;
	b := bar(b);
	if (bar(b) && bar(c)) then
		k := k + 1
	end;
	bar(true);
	i := i + j + k
end test04.
