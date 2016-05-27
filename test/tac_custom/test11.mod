module test11;
var b, c : boolean;

function foo(b0, b1 : boolean) : boolean;
begin
	return (1>2) # (b0 = b1)
	//return (b0 # b1) = (b1 # b0)
end foo;

begin
	foo(b, c)
end test11.
