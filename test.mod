//
// CAstDesignator Test.
//

module test;

var A: integer[5];
    i: integer;

procedure Set(P: integer[]; v: integer);
begin
  P[v] := 1
end Set;

procedure print;
var i: integer;
begin
  i := 0;
  while (i < 5) do
    WriteInt(A[i]);
    WriteLn();
    i := i + 1
  end
end print;

begin
  WriteInt(11111111);
  WriteLn();
  A[2] := 3;
  i := A[2];
  Set(A, i)
end test.
