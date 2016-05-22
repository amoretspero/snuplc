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