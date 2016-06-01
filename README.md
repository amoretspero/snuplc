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
  
**2016-05-31 20:56 KST**  
Fixed bug with parameter index in <code>parser.cpp</code>.  
Implemented <code>CBackendx86::ComputeStackOffset</code> for boolean, char typed parameters and local variables.  
Basic alignment has been made.  
  
**2016-05-31 20:05 KST**  
Fixed alignment problem with <code>setw</code> function and <code>std::right</code>.  
Now start to implement <code>CBackendx86::Operand</code> and <code>CBackendx86::EmitInstruction</code>.  
  
**2016-06-01 01:07 KST**  
Support <code>opSub</code>, <code>opMul</code>, <code>opDiv</code> for emitting instructions.  
Implemented <code>CBackendx86::Operand</code> function for case of <code>CTacConst</code>, <code>CTacName</code>, <code>CTacTemp</code>.  
Now source code uses more predefined functions, such as <code>CBackendx86::Load</code>, <code>CBackendx86::Store</code> and so on.  
Fixed problem of <code>CTacTemp</code> without offset and base register. Cause was inappropriate calling of <code>CBackendx86::EmitCodeBlock</code>.  
At <code>CBackendx86::EmitScope</code>, <code>CBackendx86::EmitCodeBlock</code> should be called with current scope, which is given as parameter.  
  
**2016-06-01 16:03 KST**  
Fixed bug for stack initialization. When stack offset used is zero, need not to initialize.  
Implemented <code>CBackendx86::EmitInstruction</code> function for case of <code>opAddress</code>, <code>opGoto</code>, <code>relOp</code>, <code>opParam</code>, <code>opCall</code>.  
Added array and pointer type support at <code>CBackendx86::ComputeStackOffset</code> for local and parameter.  
Implemented <code>CBackendx86::OperandSize</code> function. Simple method is used, so verification is needed for complex cases.