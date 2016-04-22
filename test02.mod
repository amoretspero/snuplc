// 
// test02.mod : Test for basic procedure/function/variable declaration.
//
// Variables : Two variables will be declared, one is basic type variable, one is qualident type variable.
// Procedure : Three procedures will be declared, one with no param, one with basic type param, one with qualident type params.
// Functions : Six functions will be declared, two with no param, two with basic type params, two with qualident type params.
// Note that each function will have variation, which will test return type of basic type or qualident type.
//
module test02;

var a, b, c: integer;
    d, e, f: boolean;
    g, h, i: char;
    arr: integer[3][3];

procedure foo();
begin
end foo;

procedure bar(param: integer; parambool: boolean; paramchar: char);
begin
end bar;

procedure foobar(param: integer[][]);
begin
end foobar;

function fn(): boolean;
begin
end fn;

function func(): integer[5];
begin
end func;

function fnc(a: integer; b: boolean): integer;
begin
end fnc;

function fncfnc(a: integer; c: char): char[5];
begin
end fncfnc;

function fnfn(a: integer; b: boolean[5]): integer;
begin
end fnfn;

function fnfnfn(a: integer; b: boolean[][]): char[5];
begin
end fnfnfn;

begin
end test02.
