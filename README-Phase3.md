# SnuPL/1 Compiler
This is compiler implementation for **SnuPL/1 language**,
for **2016-spring Compilers class @ Seoul National University**.

## SnuPL/1
SnuPL/1 language is based on Oberon programming language.  

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
  
**2016-05-12 16:15 KST**  
Changed <code>script_gen.fs</code> to be compilable in F# 3.0 also.  
Fixed bug in parameter duplication check.  Now <code>GetOneTypeParam()</code> function takes iterative with vector approach.  
Added support for multiple integer negation, for example <code>-(-(-12345))</code> will be parsed as just <code>-12345</code>.  
Changed some error messages.  
Changed line end characters from <code>\r\n</code> to <code>\n</code>.  
  
**2016-05-12 18:17 KST**  
Added some more test in <code>semantics.mod</code>  
Need to be scripted.  
  
**2016-05-14 13:43 KST**  
Generated more test for <code>semantics.mode</code>  
Line end characters changed from CRLF to LF.  
  
**2016-05-14 14:37 KST**  
Added comments to <code>ast.cpp</code>.  
Changed parts of <code>parser.cpp</code> are also commented.  
Added reference parser for different integer constant handling, and appropriate tests are added.  
Added tests should be scripted.  
  
**2016-05-14 16:30 KST**  
Generated more test for integer constants. Now total of 103 tests in <code>test/semanal/</code>.  
Need to add integer range check for prefix <code>+</code> and no-prefix case.
  
**2016-05-14 18:23 KST**  
Changed source files to newly bugfixed ones.  
Fixed <code>ast.cpp</code> to use only <code>Match()</code> function when comparing types.  
  
**2016-05-14 19:36 KST**  
Now <code>parser.cpp</code> uses RELAXED scheme for processing integer constant.  
Added comment for changed integer constant processing.  
  
**2016-05-14 21:57 KST**  
Fixing bug with RELAXED scheme.  
  
**2016-05-15 02:53 KST**  
Fixing bug with RELAXED scheme.  
Added more sophisticated tests for integer constants.  
Distinct tests (with only one fail line) are added.  
  
**2016-05-15 19:12 KST**  
Fixing bug with RELAXED scheme.  
Almost dealt with integer constant foldings.  
Should solve segfault problem for binary addition.  
  
**2016-05-15 20:35 KST**  
Almost fixed bug with RELAXED scheme.  
Need to get response to bug report about reference RELAXED scheme parser.  
Bug : ref parser parses <code>-a * b + c</code> as <code>neg(add(mul(a, b), c))</code> where as
appropriate parsing should be <code>add(neg(mul(a, b)), c)</code> which SIMPLE scheme parser does.  
  
**2016-05-15 23:37 KST**  
Fixed bug with parser. While-statement condition is only boolean-allowed, and error message for the situation
when there are no arguments but arguments are needed to appropriate one.  
Commented <code>TypeCheck()</code> and <code>GetType()</code> methods in <code>ast.cpp</code>.  
Commented changed parts of <code>parser.cpp</code>.  
Bug report response is needed.  
  
**2016-05-16 16:15 KST**  
Got bug report response.  
Result : Reference parser bug.  
<code>-a + b</code> should be parsed as <code>add(neg(a), b)</code>.  
But there is no specific semantic rule in SnuPL/1, so implementation might vary.  
Saved <code>snuplc</code> folder with debug codes in seperate folder.  
Deleted all debug codes.  
  
**2016-05-16 16:36 KST**  
Finished with all code and report.  
Semantic Analysis phase is submitted.  
LAST COMMIT of SEMANTIC ANALYSIS PHASE.
