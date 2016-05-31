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
Code Generation 
  
### Detailed status
**2016-05-30 12:01 KST**  
Initialized Phase 5.  
  
**2016-05-30 12:06 KST**  
Compilation success.  
Added <code>int size = 4;</code> line at <code>backend.cpp</code>. May need fix at later.  
For <code>CTacReference</code>, its prototype has been changed to take two arguments, so added original array's symbol for second argument.  
  
**2016-05-31 14:52 KST**  
Changed reference compiler with bugfixed one.  
Added function prologue and epilogue.  
  
**2016-05-31 16:40 KST**  
Implemented basic <code>EmitInstruction</code> for opAdd.  
Implementing <code>CBackendx86::ComputeStackOffset</code>.  
  
**2016-05-31 18:03 KST**  
Implemented <code>CBackendx86::ComputeStackOffset</code> for integer typed parameters and local variables.  
Added stack initialization at generation of function prologue.  
For stack size smaller than 20 bytes(five 32-bit words), initialize with <code>movl %eax, (offset)(%esp)</code> instruction.  
For stack size equal to or larger than 20 bytes(five 32-bit words), initialize with <code>rep</code> and <code>stosl</code> instruction.   
For more information about <code>rep</code> and <code>stosl</code> instruction, please visit below links.  
[rep - Oracle documentation](https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-64/index.html)  
[stosl - Oracle documentaion](https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-60/index.html)  