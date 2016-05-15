module semantics;

procedure While();
var a,b: integer;
begin
  while (a) do   // fail
    b := b-1
  end
end While;

begin
end semantics.
