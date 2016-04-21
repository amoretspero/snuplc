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
Implemented basic features for <code>type</code>, <code>module</code>.     
Support module and global variable declaration.  
Basic types(<code>boolean</code>, <code>char</code>, <code>integer</code>) are supported.  
  
**2016-04-18 22:48 KST**  
Added support for procedure declaration in module.  
Might not be correct implementation, so need verification.   
Method for <code>subroutineCall</code> implemented.  
Call for function or procedure might not be correct.  
Started to implement statements for if, while, return.  
  
**2016-04-19 01:10 KST**  
Added support for array and pointer type.  
Function <code>subroutineCall</code> now deals with procedure/function arguments.  
Now <code>assignment</code> function generates assignment as written in SnuPL/1 grammar.  
This makes LHS of assignment to be <code>qualident</code>, not <code>number</code> as before.  
  
**2016-04-19 01:55 KST**  
Comment current work and improved <code>README.md</code>.  
Fixed a bug in <code>module()</code> function that local variables ALWAYS have to exist in procedure.  
  
**2016-04-19 02:45 KST**  
Implemented <code>simpleexpr</code>, <code>term</code> for SnuPL/1.  
  
**2016-04-19 04:02 KST**  
Commented <code>simpleexpr</code>, <code>term</code> and added some TODOs.  
Implemented <code>factor</code> and commented it. May need some more thinking about escape characters.  
Need code review and (if needed) additional function or bug fixes.  
  
**2016-04-21 17:37 KST**
Implemented <code>if</code>, <code>while</code>, <code>return</code> statements.  
Added support for multiple function declaration in module.  
Revised functions related to fetching parameters for procedure/function. Now they use <code>vector</code> types.  
  
**2016-04-21 18:52 KST**
Added predefined functions in <code>InitSymbolTable()</code> function.
Changed <code>type()</code> function to provide pointer to array when <code>_isParam</code> is <code>true</code>,
and array when <code>_isParam</code> is <code>false</code>.  
  
  
### Notice
Arrays do not have to support array assignments.  
(Of course, its syntatically correct, but type checking phase will deal with it.)  
Array parameters are passed as references.  
(This needs adding ptr type for array.)  
Ptr to array and array itself will differ when assigning value to its element.  
When Ptr to array is being passed, we do not have to cast it once more to ptr.  
<code>WriteLn()</code> does not take parameter.  
