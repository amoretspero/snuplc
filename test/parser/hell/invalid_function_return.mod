//
// This test case tests that if parser detects invalid return.
//

module invalid_function_return;

var a, b: integer;
    c, d: char;
    e, f: boolean;
    A: integer[5];
    B: integer[5][5];

function returnInt(a: integer; A: integer[]): integer;
var b: integer;
begin
    b := A[a];
    return b
end returnInt;

function invalidReturn(a: integer; A: integer[]): integer;
begin
    return a := 3
end invalidReturn;

begin
end invalid_function_return.