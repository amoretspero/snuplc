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

  // TODO
  // forall s in subscopes do
  //   EmitScope(s)
  // EmitScope(program)
  
  SetScope(_m);  
  
  const vector<CScope*> subscopes = GetScope()->GetSubscopes();
  vector<CScope*>::const_iterator subscopesIter = subscopes.begin();
  while (subscopesIter != subscopes.end())
  {
    EmitScope(*subscopesIter);
    subscopesIter++;
  }
  
  EmitScope(GetScope());

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

  // TODO
  // ComputeStackOffsets(scope)
  //
  // emit function prologue
  //
  // forall i in instructions do
  //   EmitInstruction(i)
  //
  // emit function epilogue
  
  // Compute stack offsets.
  int stackOffsetResult = 0;
  //if (scope->GetParent() != NULL)
  //{
    cout << "===(DEBUG)===At CBackendx86::EmitScope(CScope *scope), when GetParent() is not NULL, scope name is : " << scope->GetName() << endl;
    stackOffsetResult = ComputeStackOffsets(scope->GetSymbolTable(), 8, -12);
  //}
  _out << endl;
  
  // Function Prologue
  stringstream content; // stringstream object for content of argument for EmitInstruction.
  
  _out << _ind << "# prologue" << endl;
  
  _out << _ind << "pushl   " << "%ebp" << endl; // Push %ebp to stack.
  
  _out << _ind << "movl    " << "%esp" << ", " << "%ebp" << endl; // Set %esp to %ebp.
  
  EmitInstruction("pushl", "%ebx", "save callee saved registers"); // Save callee saved register %ebx.
  EmitInstruction("pushl", "%esi"); // Save callee saved register %esi.
  EmitInstruction("pushl", "%edi"); // Save callee saved register %edi.
  content << "$" << stackOffsetResult << ", " << "%esp";
  EmitInstruction("subl", content.str(), "make room for locals"); // Make stack for local variables.
  
  _out << endl;
  
  if (stackOffsetResult < 20) // When stack offset is rather small. Manually set them. This may take at most 5 lines of assembly code.
  {
    EmitInstruction("xorl", "%eax, %eax", "memset local stack area to 0"); // Make %eax as zero.
    int stackOffsetWordCnt = stackOffsetResult/4; // Get how many word(32-bit) should be initialized.
    while (stackOffsetWordCnt > 0) // Initialize stack for local variables.
    {
      _out << _ind << "movl    " << "%eax" << ", " << (stackOffsetWordCnt-1)*4 << "(%esp)" << endl;
      stackOffsetWordCnt--;
    }
  }
  else // When stack offset is rather big. Use cld, rep, stosl to initialize stack for local variables.
  {
    EmitInstruction("cld", "", "memset local stack area to 0"); // Clear direction flags.
    EmitInstruction("xorl", "%eax, %eax"); // Make %eax as zero.
    _out << _ind << "movl    " << "$" << stackOffsetResult/4 << ", " << "%ecx" << endl; // Calculate how many word(32-bit) should be initialized.
    EmitInstruction("movl", "%esp, %edi"); // Set relative offset for stosl instruction.
    EmitInstruction("rep", "stosl"); // Repeat stosl for %ecx times.
    // For more information of rep and stosl instruction, visit below two links.
    // rep instruction : https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-64/index.html
    // stosl instruction : https://docs.oracle.com/cd/E19455-01/806-3773/instructionset-60/index.html
  }
  
  _out << endl;
  
  // Function Body
  _out << _ind << "# function body" << endl;
   
  const list<CTacInstr*> instrList = this->GetScope()->GetCodeBlock()->GetInstr();
  list<CTacInstr*>::const_iterator instrIter = instrList.begin();
  while (instrIter != instrList.end())
  {
    EmitInstruction(*instrIter);
    instrIter++;
  }
  
  _out << endl;
  
  // Function Epilogue
  _out << "l_" << label << "_end" << ":" << endl;
  _out << _ind << "# epilogue" << endl;
  _out << _ind << "addl    " << "$" << stackOffsetResult << ", " << "%esp" << endl;
  _out << _ind << "popl    " << "%ebx" << endl;
  _out << _ind << "popl    " << "%esi" << endl;
  _out << _ind << "popl    " << "%edi" << endl;
  _out << _ind << "popl    " << "%ebp" << endl;
  _out << _ind << "ret" << endl;

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
  assert(scope != NULL);

  // TODO TODO!
  CSymtab* st = scope->GetSymbolTable();
  assert(st != NULL);
  
  vector<CSymbol*> slist = st->GetSymbols();
  
  cout << "===(DEBUG)=== At CBackendx86::EmitLocalData(CScope *scope), scope name is : " << scope->GetName() << ", size of slist is : " << slist.size() << endl;
  
  bool header = false;
  
  _out << dec;
  
  size_t localSymCnt = 0;
  
  for (localSymCnt = 0; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* s = slist[localSymCnt];
    
    const CType* symbolDataType = s->GetDataType();
    
    if (!header)
    {
      _out << _ind << "# stack offsets: " << endl;
      header = true;
    }
    
    if (s->GetSymbolType() == stLocal)
    {
      _out << _ind << "#" << setw(7) << s->GetOffset() << "(" << s->GetBaseRegister() << ")" << " " << symbolDataType->GetDataSize() << " ";
      s->print(_out);
      _out << endl;
    }
  }
  
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
    // TODO
    // unary operators
    // dst = op src1
    // TODO
    case opAdd: 
      if (dynamic_cast<CTacConst*>(i->GetSrc(1)))
      {
        cout << "===(DEBUG)===At CBackendx86::EmitInstruction(CTacInstr *i), 1st src is CTacConst* " << endl;
        if (dynamic_cast<CTacConst*>(i->GetSrc(2)))
        {
          cout << "===(DEBUG)===At CBackendx86::EmitInstruction(CTacInstr *i), 2nd src is CTacConst* " << endl;
          content << "$";
          content << dynamic_cast<CTacConst*>(i->GetSrc(1))->GetValue();
          content << ", ";
          content << "%eax";
          EmitInstruction("movl", content.str(), cmt.str());
          content.str("");
          content << "$";
          content << dynamic_cast<CTacConst*>(i->GetSrc(1))->GetValue();
          content << ", ";
          content << "%ebx";
          EmitInstruction("movl", content.str());
          content.clear();
        }
        else
        {
          cout << "===(DEBUG)===At CBackendx86::EmitInstruction(CTacInstr *i), 2nd src is not CTacConst* " << endl;
        }
      }
      break;

    // memory operations
    // dst = src1
    // TODO

    // pointer operations
    // dst = &src1
    // TODO
    // dst = *src1
    case opDeref:
      // opDeref not generated for now
      EmitInstruction("# opDeref", "not implemented", cmt.str());
      break;


    // unconditional branching
    // goto dst
    // TODO

    // conditional branching
    // if src1 relOp src2 then goto dst
    // TODO

    // function call-related operations
    // TODO

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
  string operand;

  // TODO
  // return a string representing op
  // hint: take special care of references (op of type CTacReference)

  return operand;
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

  // TODO
  // compute the size for operand t of type CTacName
  // Hint: you need to take special care of references (incl. references to pointers!)
  //       and arrays. Compare your output to that of the reference implementation
  //       if you are not sure.

  return size;
}

size_t CBackendx86::ComputeStackOffsets(CSymtab *symtab,
                                        int param_ofs,int local_ofs)
{
  assert(symtab != NULL);
  vector<CSymbol*> slist = symtab->GetSymbols();
  
  size_t localSymCnt = 0;
  
  int currentParamOffset = param_ofs;
  int currentLocalOffset = local_ofs;
  size_t occupiedStack = 0;

  // TODO
  // foreach local symbol l in slist do
  //   compute aligned offset on stack and store in symbol l
  //   set base register to %ebp
  //
  // foreach parameter p in slist do
  //   compute offset on stack and store in symbol p
  //   set base register to %ebp
  //
  // align size
  //
  // dump stack frame to assembly file
  
  // For local symbols.
  for (; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt];
    
    cout << "===(DEBUG)===At CBackendx86::ComputeStackOffsets(CSymtab *symtab, int param_ofs,int local_ofs), lsym is : " << lsym->GetName() << ", symbol type is : " << lsym->GetSymbolType() << endl;
    
    if (lsym->GetSymbolType() == stLocal)
    {
      // Case when symbol is integer type.
      if (lsym->GetDataType()->IsInt())
      {
        currentLocalOffset -= 4;
        occupiedStack += 4;
        lsym->SetOffset(currentLocalOffset);
        lsym->SetBaseRegister("%ebp");
      }
    }
  }
  
  // For parameters.
  
  for (localSymCnt = 0; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt];
    
    cout << "===(DEBUG)===At CBackendx86::ComputeStackOffsets(CSymtab *symtab, int param_ofs,int local_ofs), lsym is : " << lsym->GetName() << ", symbol type is : " << lsym->GetSymbolType() << endl;
    
    if (lsym->GetSymbolType() == stParam)
    {
      // Case when symbol is integer type.
      if (lsym->GetDataType()->IsInt())
      {
        lsym->SetOffset(currentParamOffset);
        lsym->SetBaseRegister("%ebp");
        currentParamOffset += 4;
      }
    }
  }
  
  // Align size.
  
  // Dump stack frame to assembly file.
  
  for (localSymCnt = 0; localSymCnt < slist.size(); localSymCnt++)
  {
    CSymbol* lsym = slist[localSymCnt];
    if (lsym->GetSymbolType() == stLocal || lsym->GetSymbolType() == stParam)
    {
      _out << _ind 
          << "#" << setw(7) 
          << lsym->GetOffset() 
          << "(" 
          << lsym->GetBaseRegister() 
          << ")" 
          << setw(4) 
          << lsym->GetDataType()->GetDataSize()
          << setw(3)
          << lsym
          << endl;
    }
  }
  
  
  int size = 4;
  return occupiedStack;
}
