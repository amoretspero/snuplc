module semantics;

// parameters: too many/few/wrong type of parameters
procedure Parameters(p1, p2: integer);
begin
  Parameters();             // fail
  Parameters(1);            // fail
  Parameters(true, false);  // fail
  Parameters(1,2,3);        // fail
  Parameters(1,2,3,4);      // fail

  Parameters(p2,p1);        // pass
  Parameters(1,2)           // pass
end Parameters;

begin
end semantics.
