//
// test01.mod : Test module with no subroutine, only global variables and basic types.
//

module test;
var a : integer;
    i : integer;
    j : integer;
    b : boolean;
    c : boolean;
begin
//i := -2147483648 + 2147483648                // fail
//i := -2147483648 + (-(2147483648))           // fail
//i := -(-(2147483648) * (-2147483648 + ((2147483648)))) // fail
//i := (2147483647 - (-(2147483648)))          // fail
//i := -(-2147483648) * -(2147483648)          // fail
//i := ((2147483648))                          // fail
//i := -(-(2147483648))                        // fail
//i := -2147483648 * (-(2147483647 * (i - (-2147483648)))) // fail
//i := -i * -j                                 // fail
//i := +(-(+2147483648))                       // fail
//i := +(2147483647) + (-2147483648 * (-((+2147483648)))) // fail
//i := -(+(-2147483647) - (+2147483647)) * (-(+((-i))) + (-(+(+((2147483648)))))) // fail
//i := -(+((-(+2147483648))))                  // fail
//i := +i + +j                                   // fail
//i := +i - (+j * (-2147483648) / (+(+2147483648))) // fail
//i := +(2147483647) - (-i * (+i + (+j - (-j - 2147483648)))) // fail
//i := +2147483648 + 2147483647                // fail
//i := +((+2147483647)) * (-2147483648) + +i   // fail
//i := -i + (+j) * (+2147483647) - (-(+2147483649)) //fail
//i := +i + (+j * ((+i * (((-j / ((+(+((i * 2147483648))))))))))) //fail
//a := -i + 2
	a := - 1234 * 2345 / 3456;
	a := - 1234 * 2345
end test.
