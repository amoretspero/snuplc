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
Parser phase.

### Detailed status
**2016-04-18 18:05 KST**  
Implemented basic features for type, module.     
Support module and global variable declaration.  
Bool, Char, Int types are supported.  
  
**2016-04-18 22:48 KST**  
Added support for procedure decl in module.  
Might not be correct implementation, so need verification.   
Method for subroutineCall implemented.  
Call for function or procedure might not be correct.  
Started to implement statements for if, while, return.  
  
**2016-04-19 01:10 KST**  
Added support for array and pointer type.  
Function subroutineCall now deals with procedure/function arguments.  
Now assignment function generates assignment as written in SnuPL/1 grammar.  
This makes LHS of assignment to be qualident, not number as before.  
  
**2016-04-19 01:55 KST**  
Comment current work and improved README.md.  
Fixed a bug in module() function that local variables ALWAYS have to exist in procedure.  
  
**2016-04-19 02:45 KST**
Implemented simpleexpr, term for SnuPL/1.

**2016-04-19 04:02 KST**
Commented simpleexpr, term and added some TODOs.  
Implemented factor and commented it. May need some more thinking about escape characters.  
Need code review and (if needed) additional function or bug fixes.