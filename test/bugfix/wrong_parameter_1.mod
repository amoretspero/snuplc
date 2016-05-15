module arrays;

var A: integer[10];             // pass
    B: integer[10][5][10];      // pass
    D: boolean[5];              // pass

procedure p2(a: integer[][5][]);  // pass
var b: integer[5][5][5];          // pass
    c: integer[5][7][9];          // pass
begin
  p2(1);                          // fail
  p2(a[0]);                       // fail
  p2(a, a);                       // fail

  p2(B);                          // pass
  p2(b);                          // pass
  p2(c);                          // fail

  a[0][0][0] := 0
end p2;

function strcpy(src, dst: char[]): char[];  // fail
//function strcpy(src, dst: char[]): char[5]; // fail
//function strcpy(src, dst: char[]): integer; // pass
var res10: char[10];
    res5 : char[5];
begin
  return res10;                   // fail
  return res5;                    // fail

  return;                         // fail

  return 1
end strcpy;

begin
end arrays.

