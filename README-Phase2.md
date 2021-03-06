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
  
**2016-04-22 19:21 KST**  
Fixed compilation errors.  
Main errors were <code>const</code> type conversion errors, solved by <code>dynamic_cast</code>.  
  
**2016-04-23 01:11 KST**  
Fixed order of <code>procedure</code>/<code>function</code> parameters.  
Now parameters are added to <code>procedure</code>/<code>function</code>'s symbol and scope.  
Iteration through <code>vector</code> class is done with <code>iterator</code>/<code>reverse_iterator</code>.  
  
**2016-04-23 22:53 KST**  
Fixed null <code>token</code> errors.  
Problems related to <code>CToken</code> <code>GetValue()</code> function is resolved.  
More code for debugging.  
Passes <code>char03.mod</code> test.  
  
**2016-04-24 03:23 KST**  
Fixed type related errors.  
Implemented some <code>CAstNode</code>'s <code>GetType()</code> functions.  
Parsing is done to <code>char0?.mod</code> files and <code>test0?.mod</code> files.  
Result may not be correct.   
  
**2016-04-24 12:20 KST**  
Fixed <code>dynamic_cast</code> type unmatching error.  
Now <code>term</code> only consists of <code>number</code> is converted to negative number when
preceding minus sign(<code>-</code>) is present.    
  
**2016-04-24 20:11 KST**  
Passes all default tests without bugs.  
Added more tests for complex codes and should-throw-error cases.  
Need to pass <code>strange</code> tests. They are in <code>test/parser/strnage</code> folder.  
  
**2016-04-26 16:31 KST**  
Working on strange tests.  
Fixed parameter, variable duplication errors.  
Changed name unmatch error messages as same as reference parser.  
  
**2016-04-26 18:16 KST**  
Fixed <code>GetType()</code> function for <code>CAstBinaryOp</code>.  
<code>CAstBinaryOp</code> function now returns <code>NULL</code> when type of lhs and rhs are different,
or when at least one of them are <code>NULL</code>.  
  
**2016-04-26 20:18 KST**  
Added more complicated tests. They are in folder <code>test/parser/hell</code>.  
Fixed token mismatch bug in <code>scanner.cpp</code>. <code>tType</code> was not included in <code>ETokenName</code>.  
Added symbol type check in <code>factor(CAstScope* s)</code> function.  
When subroutineCall is expected, it will throw error if <code>stProcedure</code> is not given.  
When non-subroutineCall is expected, it will throw error if <code>stProcedure</code> is given.  
Test for subroutineCall is done with <code>dynamic_cast</code> to <code>const CSymProc*</code>,
and test for non-subroutineCall is done with <code>GetSymbolType()</code> function.  
  
**2016-04-27 01:11 KST**  
Commented <code>parser.cpp</code>.  
  
**2016-04-27 13:17 KST**  
Commented <code>parser.h</code>, <code>ast.cpp</code>.  
Need to get rid of unused functions.  
  
**2016-04-27 19:25 KST**  
Removed debugging code.  
Code with debugging code is in seperate folder.  
  
**2016-04-28 23:36 KST**  
Generated doxygen documents, added more tests for invalid usage of semicolons.  
Parser phase is submitted.  
LAST COMMIT of PARSER phase.  
   
  
    
### Notice
Arrays do not have to support array assignments.  
(Of course, its syntatically correct, but type checking phase will deal with it.)  
Array parameters are passed as references.  
(This needs adding ptr type for array.)  
Ptr to array and array itself will differ when assigning value to its element.  
When Ptr to array is being passed, we do not have to cast it once more to ptr.  
<code>WriteLn()</code> does not take parameter.  
