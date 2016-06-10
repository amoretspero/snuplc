//------------------------------------------------------------------------------
/// @brief SnuPL backend
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/11/28 Bernhard Egger created
/// 2013/06/09 Bernhard Egger adapted to SnuPL/0
/// 2016/04/04 Bernhard Egger adapted to SnuPL/1
///
/// @section license_section License
/// Copyright (c) 2012-2016 Bernhard Egger
/// All rights reserved.
///
/// Redistribution and use in source and binary forms,  with or without modifi-
/// cation, are permitted provided that the following conditions are met:
///
/// - Redistributions of source code must retain the above copyright notice,
///   this list of conditions and the following disclaimer.
/// - Redistributions in binary form must reproduce the above copyright notice,
///   this list of conditions and the following disclaimer in the documentation
///   and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
/// IMPLIED WARRANTIES OF MERCHANTABILITY  AND FITNESS FOR A PARTICULAR PURPOSE
/// ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER  OR CONTRIBUTORS BE
/// LIABLE FOR ANY DIRECT,  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSE-
/// QUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF  SUBSTITUTE
/// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
/// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT
/// LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY
/// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
/// DAMAGE.
//------------------------------------------------------------------------------

#include <fstream>
#include <sstream>
#include <iomanip>
#include <cassert>

#include "backend.h"
using namespace std;


//------------------------------------------------------------------------------
// CBackend
//
CBackend::CBackend(ostream &out)
  : _out(out)
{
}

CBackend::~CBackend(void)
{
}

bool CBackend::Emit(CModule *m)
{
  assert(m != NULL);
  _m = m;

  if (!_out.good()) return false;

  bool res = true;

  try {
    EmitHeader();
    EmitCode();
    EmitData();
    EmitFooter();

    res = _out.good();
  } catch (...) {
    res = false;
  }

  return res;
}

void CBackend::EmitHeader(void)
{
}

void CBackend::EmitCode(void)
{
}

void CBackend::EmitData(void)
{
}

void CBackend::EmitFooter(void)
{
}


//------------------------------------------------------------------------------
// CBackendx86
//
CBackendx86::CBackendx86(ostream &out)
  : CBackend(out), _curr_scope(NULL)
{
  _ind = string(4, ' ');
}

CBackendx86::~CBackendx86(void)
{
}

void CBackendx86::EmitHeader(void)
{
  _out << "##################################################" << endl
       << "# " << _m->GetName() << endl
       << "#" << endl
       << endl;
}

void CBackendx86::EmitCode(void)
{
  _out << _ind << "#-----------------------------------------" << endl
       << _ind << "# text section" << endl
       << _ind << "#" << endl
       << _ind << ".text" << endl
       << _ind << ".align 4" << endl
       << endl
       << _ind << "# entry point and pre-defined functions" << endl
       << _ind << ".global main" << endl
       << _ind << ".extern DIM" << endl
       << _ind << ".extern DOFS" << endl
       << _ind << ".extern ReadInt" << endl
       << _ind << ".extern WriteInt" << endl
       << _ind << ".extern WriteStr" << endl
       << _ind << ".extern WriteChar" << endl
       << _ind << ".extern WriteLn" << endl
       << endl;

  
  SetScope(_m); // Set scope to module.
  
  const vector<CScope*> subscopes = GetScope()->GetSubscopes(); // Get subscopes.
  vector<CScope*>::const_iterator subscopesIter = subscopes.begin();
  while (subscopesIter != subscopes.end()) // Iterates through subscopes and emit each of them.
  {
    SetScope(*subscopesIter); // Set current scope to subscope.
    EmitScope(*subscopesIter); // Emit subscope.
    SetScope(_m); // Set current scope to module.
    subscopesIter++; // Go to next subscope.
  }
  
  EmitScope(GetScope()); // Emit current scope.

  _out << _ind << "# end of text section" << endl
       << _ind << "#-----------------------------------------" << endl
       << endl;
}

void CBackendx86::EmitData(void)
{
  _out << _ind << "#-----------------------------------------" << endl
       << _ind << "# global data section" << endl
       << _ind << "#" << endl
       << _ind << ".data" << endl
       << _ind << ".align 4" << endl
       << endl;

  EmitGlobalData(_m);

  _out << _ind << "# end of global data section" << endl
       << _ind << "#-----------------------------------------" << endl
       << endl;
}

void CBackendx86::EmitFooter(void)
{
  _out << _ind << ".end" << endl
       << "##################################################" << endl;
}

void CBackendx86::SetScope(CScope *scope)
{
  _curr_scope = scope;
}

CScope* CBackendx86::GetScope(void) const
{
  return _curr_scope;
}

void CBackendx86::EmitScope(CScope *scope)
{
  assert(scope != NULL);

  string label;

  if (scope->GetParent() == NULL) label = "main";
  else label = scope->GetName();

  // label
  _out << _ind << "# scope " << scope->GetName() << endl
       << label << ":" << endl;
  
  // Compute stack offsets.
  size_t stackOffsetResult = 0;
  stackOffsetResult = ComputeStackOffsets(scope->GetSymbolTable(), 8, -12); // Compute stack offset.
  _out << endl;
  
  // Function Prologue
  stringstream content; // stringstream object for content of argument for EmitInstruction.
  
  _out << _ind << "# prologue" << endl;
  
  EmitInstruction("pushl", "%ebp"); // Push %ebp to stack.
  
  EmitInstruction("movl", "%esp, %ebp"); // Set %esp to %ebp.
  
  EmitInstruction("pushl", "%ebx", "save callee saved registers"); // Save callee saved register %ebx.
  EmitInstruction("pushl", "%esi"); // Save callee saved register %esi.
  EmitInstruction("pushl", "%edi"); // Save callee saved register %edi.
  content << "$" << stackOffsetResult << ", " << "%esp";
  EmitInstruction("subl", content.str(), "make room for locals"); // Make stack for local variables.
  
  if (stackOffsetResult > 0)
  {
    _out << endl;
  }
  
  if (stackOffsetResult < 20 && stackOffsetResult > 0) // When stack offset is rather small. Manually set them. This may take at most 5 lines of assembly code.
  {
    EmitInstruction("xorl", "%eax, %eax", "memset local stack area to 0"); // Make %eax as zero.
    int stackOffsetWordCnt = stackOffsetResult/4; // Get how many word(32-bit) should be initialized.
    while (stackOffsetWordCnt > 0) // Initialize stack for local variables.
    {
      content.str("");
      content << "%eax" << ", " << (stackOffsetWordCnt-1)*4 << "(%esp)";
      //_out << _ind << "movl    " << "%eax" << ", " << (stackOffsetWordCnt-1)*4 << "(%esp)" << endl;
      EmitInstruction("movl", content.str());
      stackOffsetWordCnt--;
    }
    //_out << endl;
  }
  else if (stackOffsetResult >= 20) // When stack offset is rather big. Use cld, rep, stosl to initialize stack for local variables.
  {
    EmitInstruction("cld", "", "memset local stack area to 0"); // Clear direction flags.
    EmitInstruction("xorl", "%eax, %eax"); // Make %eax as zero.
    content.str("");
    content << "$" << stackOffsetResult/4 << ", " << "%ecx";
    //_out << _ind << "movl    " << "$" << stackOffsetResult/4 << ", " << "%ecx" << endl; // Calculate how many word(32-bit) should be initialized.
    EmitInstruction("movl", content.str()); // Calculate how many word(32-bit) should be initialized.
    EmitInstruction("mov", "%esp, %edi"); // Set relative offset for stosl instruction.
    EmitInstruction("rep", "stosl"); // Repeat stosl for %ecx times.
    //_out << endl;
    // For more information of rep and stosl instruction, visit below two links.
    // rep instruction : https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-64/index.html
    // stosl instruction : https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-60/index.html
  }
  
  // Emit Local Data.
  if (scope->GetParent() != NULL)
  {
    EmitLocalData(GetScope());
  }
  else
  {
    _out << endl;
  }
  
  // Function Body
  _out << _ind << "# function body" << endl;
   
  EmitCodeBlock(scope->GetCodeBlock()); // Emit instructions in code block of given scope.
  
  _out << endl;
  
  // Function Epilogue
  if (scope->GetParent() != NULL)
  {
    _out << "l_" << label << "_exit" << ":" << endl; // Function epilogue label.
  }
  else
  {
    _out << "l_" << _m->GetName() << "_exit" << ":" << endl;
  }
  
  _out << _ind << "# epilogue" << endl;
  
  content.str(""); // Initialize content stringstream object.
  content << "$" << stackOffsetResult << ", " << "%esp";
  EmitInstruction("addl", content.str(), "remove locals"); // Remove locals on stack.
  
  EmitInstruction("popl", "%edi"); // Restore callee saved register %ebx.
  EmitInstruction("popl", "%esi"); // Restore callee saved register %esi.
  EmitInstruction("popl", "%ebx"); // Restore callee saved register %edi.
  
  EmitInstruction("popl", "%ebp"); // Restore base register %ebp.
  
  EmitInstruction("ret"); // Return from this function.

  _out << endl;
}

void CBackendx86::EmitGlobalData(CScope *scope)
{
  assert(scope != NULL);

  // emit the globals for the current scope
  CSymtab *st = scope->GetSymbolTable();
  assert(st != NULL);

  bool header = false;

  vector<CSymbol*> slist = st->GetSymbols();

  _out << dec;

  size_t size = 0;

  for (size_t i=0; i<slist.size(); i++) {
    CSymbol *s = slist[i];
    const CType *t = s->GetDataType();

    if (s->GetSymbolType() == stGlobal) {
      if (!header) {
        _out << _ind << "# scope: " << scope->GetName() << endl;
        header = true;
      }

      // insert alignment only when necessary
      if ((t->GetAlign() > 1) && (size % t->GetAlign() != 0)) {
        size += t->GetAlign() - size % t->GetAlign();
        _out << setw(4) << " " << ".align "
             << right << setw(3) << t->GetAlign() << endl;
      }

      _out << left << setw(36) << s->GetName() + ":" << "# " << t << endl;

      if (t->IsArray()) {
        const CArrayType *a = dynamic_cast<const CArrayType*>(t);
        assert(a != NULL);
        int dim = a->GetNDim();

        _out << setw(4) << " "
          << ".long " << right << setw(4) << dim << endl;

        for (int d=0; d<dim; d++) {
          assert(a != NULL);

          _out << setw(4) << " "
            << ".long " << right << setw(4) << a->GetNElem() << endl;

          a = dynamic_cast<const CArrayType*>(a->GetInnerType());
        }
      }

      const CDataInitializer *di = s->GetData();
      if (di != NULL) {
        const CDataInitString *sdi = dynamic_cast<const CDataInitString*>(di);
        assert(sdi != NULL);  // only support string data initializers for now

        _out << left << setw(4) << " "
          << ".asciz " << '"' << sdi->GetData() << '"' << endl;
      } else {
        _out  << left << setw(4) << " "
          << ".skip " << dec << right << setw(4) << t->GetDataSize()
          << endl;
      }

      size += t->GetSize();
    }
  }

  _out << endl;

  // emit globals in subscopes (necessary if we support static local variables)
  vector<CScope*>::const_iterator sit = scope->GetSubscopes().begin();
  while (sit != scope->GetSubscopes().end()) EmitGlobalData(*sit++);
}

void CBackendx86::EmitLocalData(CScope *scope)
{
  assert(scope != NULL); // Scope should not be NULL.

  CSymtab* st = scope->GetSymbolTable(); // Get symbol table.
  assert(st != NULL);
  
  vector<CSymbol*> slist = st->GetSymbols(); // List of symbols for current scope.
  
  stringstream content;
  stringstream cmt;
  
  
  vector<CSymbol*>::const_iterator symbolIter = slist.begin();
  while (symbolIter != slist.end())
  {
    CSymbol* sym = *symbolIter;
    if (sym->GetDataType()->IsArray()) // In EmitLocalData, we only initialize local arrays.
    {
      const CArrayType* arrType = dynamic_cast<const CArrayType*>(sym->GetDataType());
      int dimCnt = arrType->GetNDim(); // Number of dimensions.
      
      // Write first metadata, i.e. number of dimensions.
      content << "$";
      content << dimCnt;
      content << ",";
      content << sym->GetOffset();
      content << "(";
      content << sym->GetBaseRegister();
      content << ")";
      cmt << "local array '";
      cmt << sym->GetName();
      cmt << "': ";
      cmt << dimCnt;
      cmt << " dimensions";
      EmitInstruction("movl", content.str(), cmt.str());
      content.str("");
      cmt.str("");
      
      int dimElemCnt = 0;
      while (dimElemCnt < dimCnt) // Iterates through dimensions and write each dimention's size.
      {
        content << "$";
        content << arrType->GetNElem();
        content << ",";
        content << sym->GetOffset() + 4 * (dimElemCnt + 1); // Metadata for each dimension is stored in order.
        content << "(";
        content << sym->GetBaseRegister();
        content << ")";
        cmt << "  ";
        cmt << "dimension ";
        cmt << dimElemCnt+1;
        cmt << ": ";
        cmt << arrType->GetNElem();
        cmt << " elements";
        EmitInstruction("movl", content.str(), cmt.str());
        content.str("");
        cmt.str("");
        dimElemCnt++;
        arrType = dynamic_cast<const CArrayType*>(arrType->GetInnerType()); // Get into inner array.
      }
      
      //_out << endl;
    }
    symbolIter++; // Go to next symbol.
  }
  _out << endl;
}

void CBackendx86::EmitCodeBlock(CCodeBlock *cb)
{
  assert(cb != NULL);

  const list<CTacInstr*> &instr = cb->GetInstr();
  list<CTacInstr*>::const_iterator it = instr.begin();

  while (it != instr.end()) EmitInstruction(*it++);
}

void CBackendx86::EmitInstruction(CTacInstr *i)
{
  assert(i != NULL);

  ostringstream cmt;
  ostringstream content;
  string mnm;
  cmt << i;

  EOperation op = i->GetOperation();

  switch (op) {
    // binary operators
    // dst = src1 op src2
    case opAdd:
    case opSub: 
      //
      // For addition/subtraction of dst <- src1 +(-) src2, we follow the rule:
      // 1) Load operand src1 to eax.
      // 2) Load operand src2 to ebx.
      // 3) Add/Subtract value of ebx to eax. (Instruction : addl/subl %ebx, %eax)
      // 4) Store value of eax to dst.
      //
      
      Load(i->GetSrc(1), "%eax", cmt.str());
      
      Load(i->GetSrc(2), "%ebx", "");
      
      content << "%ebx";
      content << ", ";
      content << "%eax";
      if (op == opAdd) { EmitInstruction("addl", content.str()); } else { EmitInstruction("subl", content.str()); }
      content.str("");
      
      Store(i->GetDest(), 'a', "");
      break;
    
    case opMul:
    case opDiv:
      //
      // For multiplication/division of dst <- src1 *(/) src2, we follow the rule:
      // 1) Load operand src1 to eax.
      // 2) Load operand src2 to ebx.
      // 3) If opDiv, sign-extend [EAX] to [EDX:EAX]. (Instruction : cdq)
      // 4) Multiply/Divide value of eax by ebx. (Instruction : imull/idivl %ebx)
      // 5) Store value of eax to dst.
      //
      
      Load (i->GetSrc(1), "%eax", cmt.str());
      
      Load (i->GetSrc(2), "%ebx", "");
      
      if (op == opDiv) { EmitInstruction("cdq", ""); }
      
      if (op == opMul) { EmitInstruction("imull", "%ebx"); } else { EmitInstruction("idivl", "%ebx"); }
      
      Store(i->GetDest(), 'a', "");
      break;

    // unary operators
    // dst = op src1
    case opNeg:
      //
      // For unary negative, positive of dst <- src1, we follow the rule:
      // 1) Load operand src1 to eax.
      // 2) If opNeg, negate value. (Instruction : negl %eax)
      // 3) Store value of eax to dst.
      //
      Load(i->GetSrc(1), "%eax", cmt.str());
      
      if (op == opNeg) { EmitInstruction("negl", "%eax"); }
      
      Store(i->GetDest(), 'a');
      break;

    // memory operations
    // dst = src1
    case opAssign:
      //
      // For assignment of dst <- src1, we follow the rule:
      // 1) Get operand src1 to eax.
      // 2) Move value of eax to dst.
      //
      
      Load(i->GetSrc(1), "%eax", cmt.str());

      Store(i->GetDest(), 'a', "");
      break;

    // pointer operations
    // dst = &src1
    // dst = *src1
    case opAddress:
      //
      // For reference operation of dst = &src1, we follow the rule:
      // 1) Get address of src1 to eax. (Instruction : leal src1, %eax)
      // 2) Store the value of eax to dst. (Instruction : movl %eax, dst)
      //
      content << Operand(i->GetSrc(1));
      content << ", ";
      content << "%eax";
      EmitInstruction("leal", content.str(), cmt.str());
      content.str("");
      
      Store(i->GetDest(), 'a');
      break;
    
    case opDeref:
      // opDeref not generated for now
      EmitInstruction("# opDeref", "not implemented", cmt.str());
      break;


    // unconditional branching
    // goto dst
    case opGoto:
      //
      // For goto of goto dst, we follow the rule:
      // 1) Unconditionally branch to l_(scopeName)_(dst).
      //
      EmitInstruction("jmp", Label(dynamic_cast<CTacLabel*>(i->GetDest())), cmt.str());
      break;

    // conditional branching
    // if src1 relOp src2 then goto dst
    case opEqual:
    case opNotEqual:
    case opBiggerEqual:
    case opBiggerThan:
    case opLessEqual:
    case opLessThan:
      //
      // For conditional branching of if src1 relOp src2 then goto dst, we follow the rule:
      // 1) Load src1 to eax.
      // 2) Load src2 to ebx.
      // 3) Compare ebx to eax. (Instruction : cmp %ebx, %eax)
      // 4) j(relOp) dst
      //
      
      Load(i->GetSrc(1), "%eax", cmt.str());
      
      Load(i->GetSrc(2), "%ebx");
      
      EmitInstruction("cmpl", "%ebx, %eax");
      
      if (op == opEqual) { EmitInstruction("je", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else if (op == opNotEqual) { EmitInstruction("jne", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else if (op == opBiggerEqual) { EmitInstruction("jge", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else if (op == opBiggerThan) { EmitInstruction("jg", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else if (op == opLessEqual) { EmitInstruction("jle", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else if (op == opLessThan) { EmitInstruction("jl", Label(dynamic_cast<CTacLabel*>(i->GetDest()))); }
      else { EmitInstruction("###", "Inavlid instruction."); }
      break;

    // function call-related operations
    case opParam:
      //
      // For adding parameter(s) of param (idx) <- src1, we follow the rule:
      // 1) Load src1 to eax.
      // 2) push eax to stack.
      //
      
      Load(i->GetSrc(1), "%eax", cmt.str());
      
      EmitInstruction("pushl", "%eax");
      break;
    
    case opCall:
      //
      // For calling function/procedure of call (dst) <- src1, we follow the rule:
      // 1) Call (src1). Result will be stored at eax.
      // 2) Add 4 to esp. This will get esp to original position.
      // 3) If function, Store the value of eax to dst.
      //
      
      EmitInstruction("call", dynamic_cast<CTacName*>(i->GetSrc(1))->GetSymbol()->GetName(), cmt.str());
      
      if (dynamic_cast<const CSymProc*>(dynamic_cast<CTacName*>(i->GetSrc(1))->GetSymbol())->GetNParams() > 0) // When parameters exist, add them.
      {
        content << "$";
        content << 4 * dynamic_cast<const CSymProc*>(dynamic_cast<CTacName*>(i->GetSrc(1))->GetSymbol())->GetNParams();
        content << ", ";
        content << "%esp";
        
        EmitInstruction("addl", content.str());
        content.str("");
      }
      
      if (i->GetDest() != NULL)
      {
        Store(i->GetDest(), 'a');
      }
      break;
    
    case opReturn:
      //
      // For return of return (src1), we follow the rule:
      // 1) Load src1 to eax.
      // 2) Jump to l_(scopeName)_exit.
      //
      
      if (i->GetSrc(1) != NULL) // When return value exist, load that.
      {
        Load(i->GetSrc(1), "%eax", cmt.str());
      }
      
      content << "l_";
      content << GetScope()->GetName();
      content << "_exit";
      
      EmitInstruction("jmp", content.str());
      break;

    // special
    case opLabel:
      _out << Label(dynamic_cast<CTacLabel*>(i)) << ":" << endl;
      break;

    case opNop:
      EmitInstruction("nop", "", cmt.str());
      break;


    default:
      EmitInstruction("# ???", "not implemented", cmt.str());
  }
}

void CBackendx86::EmitInstruction(string mnemonic, string args, string comment)
{
  _out << left
       << _ind
       << setw(7) << mnemonic << " "
       << setw(23) << args;
  if (comment != "") _out << " # " << comment;
  _out << endl;
}

void CBackendx86::Load(CTacAddr *src, string dst, string comment)
{
  assert(src != NULL);

  string mnm = "mov";
  string mod = "l";

  // set operator modifier based on the operand size
  switch (OperandSize(src)) {
    case 1: mod = "zbl"; break;
    case 2: mod = "zwl"; break;
    case 4: mod = "l"; break;
  }

  // emit the load instruction
  EmitInstruction(mnm + mod, Operand(src) + ", " + dst, comment);
}

void CBackendx86::Store(CTac *dst, char src_base, string comment)
{
  assert(dst != NULL);

  string mnm = "mov";
  string mod = "l";
  string src = "%";

  // compose the source register name based on the operand size
  switch (OperandSize(dst)) {
    case 1: mod = "b"; src += string(1, src_base) + "l"; break;
    case 2: mod = "w"; src += string(1, src_base) + "x"; break;
    case 4: mod = "l"; src += "e" + string(1, src_base) + "x"; break;
  }

  // emit the store instruction
  EmitInstruction(mnm + mod, src + ", " + Operand(dst), comment);
}

string CBackendx86::Operand(const CTac *op)
{
  string operand; // Result of making operand string.

  stringstream content; // Content of operand string.
  
  const CTacConst* constCast = dynamic_cast<const CTacConst*>(op); // To check if constant.
  const CTacTemp* tempCast = dynamic_cast<const CTacTemp*>(op); // To check if temporary symbol.
  const CTacName* nameCast = dynamic_cast<const CTacName*>(op); // To check if name.
  const CTacReference* refCast = dynamic_cast<const CTacReference*>(op); // To check if reference.
  
  if (constCast != NULL) // When constant.
  {
    content << "$";
    content << constCast->GetValue(); // Get value of constant.
    operand = content.str();
  }
  else if (tempCast != NULL) // When temporary symbol.
  {
    op->print(cout);
    const CSymbol* sym = tempCast->GetSymbol(); // Get symbol for temporary symbol.
    content << sym->GetOffset(); // Get offset.
    content << "(";
    content << sym->GetBaseRegister(); // Get base register.
    content << ")";
    operand = content.str();
  }
  else if (refCast != NULL) // When reference.
  {
    const CSymbol* sym = refCast->GetSymbol(); // Get symbol for reference.
    content << sym->GetOffset(); // Get offset.
    content << "(";
    content << sym->GetBaseRegister(); // Get base register.
    content << ")";
    content << ", ";
    content << "%edi"; // Reference is stored at edi.
    EmitInstruction("movl", content.str());
    
    content.str("");
    content << "(";
    content << "%edi";
    content << ")";
    operand = content.str();
  }
  else if (nameCast != NULL) // When name.
  {
    const CSymbol* sym = nameCast->GetSymbol(); // Get symbol.
    if (sym->GetSymbolType() == stGlobal) // Global symbol.
    {
      content << sym->GetName(); // For global symbols, we can use name as it is.
      operand = content.str();
    }
    else // Local.
    {
      content << sym->GetOffset(); // Gets offset for symbol.
      content << "(";
      content << sym->GetBaseRegister(); // Gets base register for symbol.
      content << ")";
      operand = content.str();
    }
  }

  return operand; // Return generated result.
}

string CBackendx86::Imm(int value) const
{
  ostringstream o;
  o << "$" << dec << value;
  return o.str();
}

string CBackendx86::Label(const CTacLabel* label) const
{
  CScope *cs = GetScope();
  assert(cs != NULL);

  ostringstream o;
  o << "l_" << cs->GetName() << "_" << label->GetLabel();
  return o.str();
  return "l_" + cs->GetName() + "_" + label->GetLabel();
}

string CBackendx86::Label(string label) const
{
  CScope *cs = GetScope();
  assert(cs != NULL);

  return "l_" + cs->GetName() + "_" + label;
}

string CBackendx86::Condition(EOperation cond) const
{
  switch (cond) {
    case opEqual:       return "e";
    case opNotEqual:    return "ne";
    case opLessThan:    return "l";
    case opLessEqual:   return "le";
    case opBiggerThan:  return "g";
    case opBiggerEqual: return "ge";
    default:            assert(false); break;
  }
}

int CBackendx86::OperandSize(CTac *t) const
{
  int size = 4;
  
  CTacTemp* tempCast = dynamic_cast<CTacTemp*>(t); // To check if temporary symbol.
  CTacReference* refCast = dynamic_cast<CTacReference*>(t); // To check if reference.
  CTacName* nameCast = dynamic_cast<CTacName*>(t); // To check if name.
  if (tempCast != NULL) // When temporary symbol.
  {
    return tempCast->GetSymbol()->GetDataType()->GetDataSize(); // Get the size of temporary symbol's data type.
  }
  else if (refCast != NULL) // When reference.
  {
    const CSymbol* derefSym = refCast->GetDerefSymbol(); // Get the original data symbol.
    if (derefSym->GetDataType()->IsArray()) // When original data is array.
    {
      return dynamic_cast<const CArrayType*>(derefSym->GetDataType())->GetBaseType()->GetDataSize(); // Return the array's size.
    }
    else if (derefSym->GetDataType()->IsPointer()) // When original data is pointer.
    {
      return dynamic_cast<const CArrayType*>(dynamic_cast<const CPointerType*>(derefSym->GetDataType())->GetBaseType())->GetBaseType()->GetDataSize(); // Return the size of array that pointer points to.
    }
    return derefSym->GetDataType()->GetDataSize(); // Not array, nor pointer. Return dereferenced symbol's size.
  }
  else if (nameCast != NULL) // When name.
  {
    return nameCast->GetSymbol()->GetDataType()->GetSize(); // Get symbol and return data size.
  }

  return size;
}

size_t CBackendx86::ComputeStackOffsets(CSymtab *symtab,
                                        int param_ofs,int local_ofs)
{
  assert(symtab != NULL);
  vector<CSymbol*> slist = symtab->GetSymbols();
  
  size_t localSymCnt = 0;
  
  int currentParamOffset = param_ofs; // This variable keeps track of parameter offset.
  int currentLocalOffset = local_ofs; // This variable keeps track of stack offset.
  size_t occupiedStack = 0; // This variable keeps track of how many stack is used.
  
  // For local symbols.
  for (; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt]; // Symbol.
        
    if (lsym->GetSymbolType() == stLocal) // Local symbol.
    {
      if (lsym->GetDataType()->IsInt()) // Case when symbol is integer type.
      {
        // Check for alignment
        if (occupiedStack%4 != 0)
        {
          int alignRemainder = occupiedStack%4;
          occupiedStack += (4 - alignRemainder);
          currentLocalOffset -= (4 - alignRemainder);
        }
        
        currentLocalOffset -= 4; // Occupy 4 bytes.
        occupiedStack += 4; // Occupy 4 bytes.
        lsym->SetOffset(currentLocalOffset); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsBoolean()) // Case when symbol is boolean type.
      {
        currentLocalOffset -= 1; // Occupy 1 byte.
        occupiedStack += 1; // Occupy 1 byte.
        lsym->SetOffset(currentLocalOffset); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsChar()) // Case when symbol is char type.
      {
        currentLocalOffset -= 1; // Occupy 1 byte.
        occupiedStack += 1; // Occupy 1 byte.
        lsym->SetOffset(currentLocalOffset); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsArray()) // Case when symbol is array type.
      {
        // Check for alignment
        if ((occupiedStack + lsym->GetDataType()->GetSize())%4 != 0)
        {
          int alignRemainder = (occupiedStack + lsym->GetDataType()->GetSize())%4; // For array, we align with after-pushing stack.
          occupiedStack += (4 - alignRemainder);
          currentLocalOffset -= (4 - alignRemainder);
        }
        int dataSize = lsym->GetDataType()->GetSize(); // Get the data size for this array, including metadata.
        currentLocalOffset -= dataSize; // Occupy (datasize) bytes.
        occupiedStack += dataSize; // Occupy (datasize) bytes.
        lsym->SetOffset(currentLocalOffset); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsPointer()) // Case when symbol is pointer type.
      {
        // Check for alignment
        if (occupiedStack%4 != 0)
        {
          int alignRemainder = occupiedStack%4;
          occupiedStack += (4 - alignRemainder);
          currentLocalOffset -= (4 - alignRemainder);
        }
        currentLocalOffset -= 4; // Occupy 4 bytes.
        occupiedStack += 4; // Occupy 4 bytes.
        lsym->SetOffset(currentLocalOffset); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
    }
  }
  
  // For parameters.
  for (localSymCnt = 0; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt]; // Symbol.
        
    if (lsym->GetSymbolType() == stParam) // Parameter.
    {
      if (lsym->GetDataType()->IsInt()) // Case when symbol is integer type.
      {
        lsym->SetOffset(currentParamOffset + 4 * (dynamic_cast<CSymParam*>(lsym)->GetIndex() - 1)); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsBoolean()) // Case when symbol is boolean type.
      {
        lsym->SetOffset(currentParamOffset + 4 * (dynamic_cast<CSymParam*>(lsym)->GetIndex() - 1)); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsChar()) // Case when symbol is char type.
      {
        lsym->SetOffset(currentParamOffset + 4 * (dynamic_cast<CSymParam*>(lsym)->GetIndex() - 1)); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
      else if (lsym->GetDataType()->IsPointer()) // Case when symbol is pointer type.
      {
        lsym->SetOffset(currentParamOffset + 4 * (dynamic_cast<CSymParam*>(lsym)->GetIndex() - 1)); // Set offset of this symbol.
        lsym->SetBaseRegister("%ebp"); // Set base register of this symbol.
      }
    }
  }
  
  
  // Dump stack frame to assembly file.
  
  _out << _ind << "# stack offsets:" << endl;
  for (localSymCnt = 0; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt]; // Symbol.
    if (lsym->GetSymbolType() == stLocal || lsym->GetSymbolType() == stParam) // Local symbols and parameters are on stack.
    {
      int offsetInd = 7;
      if (currentLocalOffset <= -1000)
      {
        offsetInd = 8;
      }
      _out << _ind 
           << "#" 
           << "   "
           << std::right
           << setw(4)
           << lsym->GetOffset() 
           << "(" 
           << lsym->GetBaseRegister() 
           << ")" 
           << "  "
           << setw(2) 
           << lsym->GetDataType()->GetSize()
           << setw(2)
           << lsym
           << endl;
    }
  }
  
  // Check for alignment
  if (occupiedStack%4 != 0)
  {
    int alignRemainder = occupiedStack%4;
    occupiedStack += (4 - alignRemainder);
    currentLocalOffset -= (4 - alignRemainder);
  }
  
  int size = 4;
  return occupiedStack; // Return the total occupied size of stack.
}
