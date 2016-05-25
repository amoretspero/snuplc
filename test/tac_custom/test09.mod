module test09;

var i0, i1, i2 : integer;
		b0, b1, b2 : boolean;
		c0, c1, c2 : char;
		BoolArr0 : boolean[5];
		BoolArr1 : boolean[5][5];
		BoolArr2 : boolean[5][5][5];
		BoolArr3 : boolean[5][5][5];
		MatA : integer[5][5];
		MatB : integer[5][5];
		MatRes : integer[5][5];

function booltest2(p1, p2 : boolean; p3, p4 : boolean[5]) : boolean;
begin
	if (true) then
		if (false) then
			if (p3[2] && p4[1] && !p1) then
				WriteStr("Hello, World!\n");
				if (p3[0]) then
					return true
				else
					return false
				end
			else
				return p3[2] && BoolArr1[1][2] || !BoolArr2[1][4][3] || (!p3[1] && (!(!(!p4[1]))))
			end
		else
			return p1
		end
	else
		return p3[1]
	end;
	return false
end booltest2;

begin
	booltest2(true, false, BoolArr0, BoolArr0);
	b0 := booltest2(BoolArr0[2], BoolArr1[1][3], BoolArr1[2], BoolArr2[1][4]);
	b1 := !booltest2(BoolArr1[2][3], BoolArr2[1][2][3], BoolArr3[1][2], BoolArr2[0][0]);
	b0 := !(!booltest2(true, false, BoolArr3[1][2], BoolArr2[0][1]))
end test09.