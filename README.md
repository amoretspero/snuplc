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
Now <code>CAstFunctionCall</code> calls for <code>ToTac(CCodeBlock\*, CTacLabel\*, CTacLabel\*)</code> method when argument has boolean type and not a constant nor designator.  
  
**2016-05-27 23:05 KST**  
Almost fixed bug for <code>CAstBinaryOp::ToTac</code> methods and related ones.  
Now <code>CAstFunctionCall</code> and <code>CAstStatReturn</code> calls for <code>ToTac(CCodeBlock*, CTacLabel*, CTacLabel*)</code> method when
expression of argument to function or return has type of boolean and not <code>CAstConstant</code>, not <code>CAstDesignator</code>, not <code>CAstFunctionCall</code>.  
This makes those two methods call <code>ToTac(CCodeBlock*, CTacLabel*, CTacLabel*)</code> method when only expression cannot have single boolean (temporary) variable.  
Expressions which can be represented with single boolean (temporary) variable is dealt with <code>ToTac(CCodeBlock*)</code> method.  
  
**2016-05-28 00:16 KST**  
Changed temporary symbol creation order for <code>opEqual</code> and <code>opNotEqual</code> case of <code>CAstBinaryOp::ToTac(CCodeBlock\*, CTacLabe\*, CTacLabel*)</code>.  
For most of the cases, temporary symbol creation should take place right before use of it.  
  
**2016-05-28 01:08 KST**  
Fixed bug for <code>CAstBinaryOp::ToTac</code> methods and related ones.  
Dynamic test available.  
2 2 2 : Passing 2000/2000 tests.  
3 3 3 : Passing 2000/2000 tests.  
5 5 5 : Passing 500/500 tests.  
5 10 10 : Passing 207/207 tests.  
More tests can be done with more time.  
  
**2016-05-28 04:29 KST**  
Added unary operator generation for <code>modgen.py</code>. Unary operator test is available.  
Scheme for integer constant relaxing is RELAXED scheme.  
Binary operators of SnuPL/1 language is left associative. i.e., <code>1 * 2 * 3</code> should be calculated as <code>1 \* 2</code> first and <code>(prev result) \* 3</code>.  
To take consider of this fact, <code>CParser::simpleexpr</code> has been modified.  
When unary prefix is present and LHS of termOp is not constant, now unary prefix operator is applied to ONLY constant left-most operand.  
If left-most operand of term composing simpleexpr is NOT a constant, unary prefix will be applied to the whole term.  
For help, we defined two additional helper functions, one is <code>CParser::getBinaryLHS(CAstBinaryOp\* _lhs, bool _isNeg, bool _isPos)</code>, which will get the 
unary prefix applied expression of given <code>_lhs</code>, the other one is <code>CParser::isLeftmostConstant(CAstBinaryOp\* _lhs)</code>, which will tell whether
the left most operand of given binary operation is constant or not.  
Comments are needed for recently edited parts of source code.