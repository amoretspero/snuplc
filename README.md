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