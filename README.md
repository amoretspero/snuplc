# SnuPL/1 Compiler
This is compiler implementation for **SnuPL/1 language**,
for **2016-spring Compilers class @ Seoul National University**.

## SnuPL/1
SnuPL/1 language is based on Oberon programming language.
(Add more.)

## Compiler
Compiler for SnuPL/1 programming language is implemented as
class project for one semester.

## Current Status

### Implementation Phase
Sementic Analysis Phase.  
  
### Detailed status
**2016-05-10 14:28 KST**  
Added sementic analysis phase.  
Start Phase 3.  
  
**2016-05-11 02:30 KST**  
Implemented <code>TypeCheck()</code> methods for various <code>CAstNode</code>.  
Error reporting token locations should be fixed.  
Non-open array check for variable declaration should be supported.  
Error messages should be updated.  
  
**2016-05-11 02:56 KST**  
Non-open array check for variable declaration is now supported.  
There may be corner cases, verification is needed.  
  
**2016-05-11 16:46 KST**  
Changed some error messages to match with reference parser.  
Also some typecheck order is changed to match with reference parser.  
Generated line-by-line commented semantic tests.  
Test generator is <code>script_gen.fs</code>.  
Only works for windows. Other platforms will be supported later with different PL.