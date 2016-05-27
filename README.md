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
**2016-05-18 15:46 KST**  
Added Intermediate Code Generation phase.  
Start Phase 4.  
  
**2016-05-20 01:13 KST**  
Implemented boolean assignments. Scalar type only.  
Very basics of them are implemented, so continuous verification is needed.  
  
**2016-05-21 00:45 KST**  
Implemented basic binary operations, unary operations. Scalar type only.  
Assignments using above operations are possible.  
  
**2016-05-22 16:02 KST**  
Added dummy label in <code>CAstBinaryOp::ToTac</code> for relational operators.  
Implemented <code>if</code> and <code>while</code> statements.  
  
**2016-05-23 00:37 KST**  
Implemented <code>return</code> statement and function calls.  
For return statement, boolean type return and other scalar type return values are distinguished.  
For function calls, <code>CAstStatCall</code> is for function call as statement itself, i.e. <code>foo(1);</code>,
whereas <code>CAstFunctionCall</code> is for function call as expression, i.e. <code>i := foo(2);</code>.  
<code>CAstStatCall</code> will just call its function call's <code>ToTac</code> method.  
<code>CAstFunctionCall</code> will do all the TAC generating part. And for return value of function, it will return them in temporary variable.  
More improvement is needed with more tests.  
  
**2016-05-24 02:48 KST**  
Implemented <code>ToTac()</code> methods for <code>CAstArrayDesignator</code> and <code>CAstFunctionCall</code>.  
Need more tests, especially for those with array in function call arguments. And boolean related ones also need more tests.  
Should implement <code>ToTac()</code> method for boolean type <code>CAstArrayDesignator</code> and <code>ToTac()</code> for <code>CAstStringConstant</code>.  
  
**2016-05-25 03:03 KST**  
Implemented all <code>ToTac()</code> methods.  
Passing intensive array tests(<code>test/tac_custom/test07.mod</code>).  
Failing intensive boolean tests(<code>test/tac_custom/test08.mod</code>).  
  
**2016-05-25 13:23 KST**  
Fixed <code>ToTac()</code> method for <code>CAstSpecialOp</code>, <code>CAstArrayDesignator</code>, <code>CAstStatReturn</code>.  
CTac temporary variable allocation is fixed for some methods.  This is done to match result output with reference.  
Temporary variable type for <code>CAstSpecialOp</code> is fixed to represent base type of array when operand of special operation is array. Note that Array indexed fully is not array.
For example, for <code>A : integer[5][5]</code>, <code>A[1][2]</code> is not array, whereas <code>A</code> and <code>A[1]</code> is array.  
For array designators, when array is not fully indexed, now parser will add zero to result of DIM multiplied by base type size, and iterates until iteration count is same to number of arguments expected.  
Passing intensive boolean tests(<code>test/tac_custom/test08.mod</code>).  
  
**2016-05-25 18:23 KST**  
Added comments to <code>ToTac()</code> methods. Need revision.  
  
**2016-05-27 20:38 KST**  
Fixing bug for <code>CAstBinaryOp::ToTac</code> methods.  
<code>opEqual</code> and <code>opNotEqual</code> have problems.  
  
**2016-05-27 21:23 KST**  
Fixing bug for <code>CAstBinaryOp::ToTac</code> methods and related ones.  
Now <code>CAstFunctionCall</code> calls for <code>ToTac(CCodeBlock*, CTacLabel*, CTacLabel*)</code> method when argument has boolean type and not a constant nor designator.