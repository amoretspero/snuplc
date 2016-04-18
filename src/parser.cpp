//------------------------------------------------------------------------------
/// @brief SnuPL/0 parser
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2014/11/04 Bernhard Egger maintain unary '+' signs in the AST
/// 2016/04/01 Bernhard Egger adapted to SnuPL/1 (this is not a joke)
/// 2016/09/28 Bernhard Egger assignment 2: parser for SnuPL/-1
///
/// @section license_section License
/// Copyright (c) 2012-2016, Bernhard Egger
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

#include <limits.h>
#include <cassert>
#include <errno.h>
#include <cstdlib>
#include <vector>
#include <iostream>
#include <exception>

#include "parser.h"
using namespace std;

/*

--- SnuPL/1 EBNF definitions ---
(letter, digit, character, char, string, number, ident will be treated as terminals)
module              = "module" ident ";" varDeclaration { subroutineDecl } "begin" statSequence "end" ident ".".
letter              = "A".."Z" | "a".."z" | "_".
digit               = "0".."9".
character           = ASCIIchar | "\n" | "\t" | "\"" | "\'" | "\\" | "\0"
char                = "'" character "'"
string              = '"' {character} '"'.
ident               = letter { letter | digit }.
number              = digit { digit }.
boolean             = "true" | "false".
type                = basetype | type "[" [ number ] "]".
basetype            = "boolean" | "char" | "integer".
qualident           = ident { "[" expression "]" }.
factOp              = "*" | "/" | "&&".
termOp              = "+" | "-" | "||".
relOp               = "=" | "#" | "<" | "<=" | ">" | ">=".
factor              = qualident | number | boolean | char | string | "(" expression ")" | subroutineCall | "!" factor.
term                = factor { factOp factor }.
simpleexpr          = ["+"|"-"] term { termOp term }.
expression          = simpleexpr [ relOp simpleexpr ].
assignment          = qualident ":=" expression.
subroutineCall      = ident "(" [ expression {"," expression} ] ")".
ifStatement         = "if" "(" expression ")" "then" statSequence [ "else" statSequence ] "end".
whileStatement      = "while" "(" expression ")" "do" statSequence "end".
returnStatement     = "return" [ expression ].
statement           = assignment | subroutineCall | ifStatement | whileStatement | returnStatement.
statSequence        = [ statement { ";" statement } ].
varDeclaration      = [ "var" varDeclSequence ";" ].
varDeclSequence     = varDecl { ";" varDecl }.
varDecl             = ident { "," ident } ":" type.
subroutineDecl      = (procedureDecl | functionDecl) subroutineBody ident ";".
procedureDecl       = "procedure" ident [ formalParam ] ";".
functionDecl        = "function" ident [ formalParam ] ":" type ";".
formalParam         = "(" [ varDeclSequence ] ")".
subroutineBody      = varDeclaration "begin" statSequence "end".
comment             = "//" {[^\n]} \n
whitespace          = { " " | \t | \n }

--- FIRST of SnuPL/1 keywords ---
(letter, digit, character, char, string, number, ident will be treated as terminals)
module              : "module"
char                : char
string              : string
number              : number
ident               : ident
boolean             : "true" | "false"
type                : "boolean" | "char" | "integer"
qualident           : ident
factOp              : "*" | "/" | "&&"
termOp              : "+" | "-" | "||"
relOp               : "=" | "#" | "<" | "<=" | ">" | ">="
factor              : ident | number | "true" | "false" | char | string | "(" | "!"
  (CAUTION : ident is from both 'qualident' and 'subroutineCall')
term                : ident | number | "true" | "false" | char | string | "(" | "!"
  (CAUTION : ident is from both 'qualident' and 'subroutineCall')
simpleexpr          : "+" | "-" | ident | number | "true" | "false" | char | string | "(" | "!"
  (CAUTION : ident is from both 'qualident' and 'subroutineCall')
expression          : "+" | "-" | ident | number | "true" | "false" | char | string | "(" | "!"
  (CAUTION : ident is from both 'qualident' and 'subroutineCall')
assignment          : ident
subroutineCall      : ident
ifStatement         : "if"
whileStatement      : "while"
returnStatement     : "return"
statement           : ident | "if" | "while" | "return"
  (CAUTION : ident is from both 'assignment' and 'subroutineCall')
statSequence        : epsilon | ident | "if" | "while" | "return"
  (CAUTION : ident is from both 'assignment' and 'subroutineCall')
varDeclaration      : epsilon | "var"
varDeclSequence     : ident
varDecl             : ident
subroutineDecl      : "procedure" | "function"
procedureDecl       : "procedure"
functionDecl        : "function"
formalParam         : "("
subroutineBody      : "var" | "begin"

--- FOLLOW of SnuPL/1 keywords ---
(letter, digit, character, char, string, number, ident will be treated as terminals)
(Set based)
module              : $ |
boolean             : FOLLOW(factor) |
type                : "[" | FOLLOW(varDecl) | ";" | 
basetype            : FOLLOW(type)
qualident           : FOLLOW(factor) | ":=" | 
factOp              : FIRST(factor) - epsilon | 
termOp              : FIRST(term) - epsilon | 
relOp               : FIRST(simpleexpr) - epsilon | 
factor              : FOLLOW(factor) | FIRST(factOp) - epsilon | FOLLOW(term) | 
term                : FOLLOW(simpleexpr) | FIRST(termOp) - epsilon | 
simpleexpr          : FOLLOW(expression) | FIRST(relOp) - epsilon |
expression          : "]" | ")" | FOLLOW(assignment) | "," | FOLLOW(returnStatement) | 
assignment          : FOLLOW(statement) | 
subroutineCall      : FOLLOW(factor) | FOLLOW(statement) | 
ifStatement         : FOLLOW(statement) | 
whileStatement      : FOLLOW(statement) | 
returnStatement     : FOLLOW(statement) | 
statement           : FOLLOW(statSequence) | ";" | 
statSequence        : "end" | "else" | 
varDeclaration      : "begin" | FIRST(subroutineDecl) - epsilon | 
varDeclSequence     : ";" | ")" |
varDecl             : FOLLOW(varDeclSequence) | ";" | 
subroutineDecl      : "begin" | 
procedureDecl       : FIRST(subroutineBody) - epsilon |
functionDecl        : FIRST(subroutineBody) - epsilon | 
formalParam         : ";" | ":" | 
subroutineBody      : ident | 

--- FOLLOW of SnuPL/1 keywords ---
(letter, digit, character, char, string, number, ident will be treated as terminals)
(terminal based)
module              : $ |
boolean             : "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | 
type                : "[" | ")" | ";" | 
basetype            : "[" | ")" | ";" |
qualident           : "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | ":=" | 
factOp              : ident | number | "true" | "false" | char | string | "(" | "!" | 
termOp              : ident | number | "true" | "false" | char | string | "(" | "!" | 
relOp               : "+" | "-" | ident | number | "true" | "false" | char | string | "(" | "!" | 
factor              : "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | 
term                : "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | 
simpleexpr          : "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" |
expression          : "]" | ")" | "," | "end" | "else" | ";" |
assignment          : "end" | "else" | ";" | 
subroutineCall      : "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | 
ifStatement         : "end" | "else" | ";" |
whileStatement      : "end" | "else" | ";" |
returnStatement     : "end" | "else" | ";" |
statement           : "end" | "else" | ";" | 
statSequence        : "end" | "else" | 
varDeclaration      : "begin" | "procedure" | "function" | 
varDeclSequence     : ";" | ")" |
varDecl             : ";" | ")" |
subroutineDecl      : "begin" | 
procedureDecl       : "var" | "begin" |
functionDecl        : "var" | "begin" |
formalParam         : ";" | ":" | 
subroutineBody      : ident | 

*/

//------------------------------------------------------------------------------
// CParser
//
CParser::CParser(CScanner *scanner)
{
  _scanner = scanner;
  _module = NULL;
}

CAstNode* CParser::Parse(void)
{
  _abort = false;

  if (_module != NULL) { delete _module; _module = NULL; }

  try {
    if (_scanner != NULL) _module = module();

    if (_module != NULL) {
      CToken t;
      string msg;
      //if (!_module->TypeCheck(&t, &msg)) SetError(t, msg);
    }
  } catch (...) {
    _module = NULL;
  }

  return _module;
}

const CToken* CParser::GetErrorToken(void) const
{
  if (_abort) return &_error_token;
  else return NULL;
}

string CParser::GetErrorMessage(void) const
{
  if (_abort) return _message;
  else return "";
}

void CParser::SetError(CToken t, const string message)
{
  _error_token = t;
  _message = message;
  _abort = true;
  throw message;
}

bool CParser::Consume(EToken type, CToken *token)
{
  if (_abort) return false;

  CToken t = _scanner->Get();

  if (t.GetType() != type) {
    SetError(t, "expected '" + CToken::Name(type) + "', got '" +
             t.GetName() + "'");
  }

  if (token != NULL) *token = t;

  return t.GetType() == type;
}

void CParser::InitSymbolTable(CSymtab *s)
{
  CTypeManager *tm = CTypeManager::Get();

  // TODO: add predefined functions here
}

CAstModule* CParser::module(void)
{
  //
  // module              = "module" ident ";" varDeclaration { subroutineDecl } "begin" 
  //                       statSequence "end" ident ".".
  //
  /*
  CToken dummy;
  CAstModule *m = new CAstModule(dummy, "placeholder");
  CAstStatement *statseq = NULL;

  statseq = statSequence(m);
  Consume(tDot);

  m->SetStatementSequence(statseq);

  return m;
  */
  
  CSymtab moduleSymTab = new CSymtab();
  
  CToken t;
  Consume(tModule);
  
  CToken* module_id = new CToken();
  Consume(tId, module_id);
  Consume(tSemicolon);
  
  CAstModule* m = new CAstModule(t, module_id->GetValue());
  
  CTypeManager* typeManager = CTypeManager::Get();
  
  CToken checkIfVar = _scanner->Peek();
  if (checkIfVar.GetType() == tVar)
  {
    Consume(tVar);
   
    while (true)
    {
      GetVariables(_scanner, m, typeManager);
      printf("End get variables.\n");
      cout << "Next token is : " << _scanner->Peek().GetValue() << endl;
      Consume(tSemicolon);
      printf("Got semicolon of end of var decl.\n");
      if (_scanner->Peek().GetType() != tId)
      {
        break;
      }
    }
  }
  // TODO: Support for multiple functions.
  while (_scanner->Peek() == tProcedure)
  {
    Consume(tProcedure);
    
    CToken* procName = new CToken();
    Consume(tId, procName);
    
    CSymProc* procSymbol = new CSymProc(procName->GetValue(), NULL);
    m->GetSymbolTable()->AddSymbol(procSymbol);
    
    CAstProcedure* procScope = new CAstProcedure(procName, procName->GetValue(), m, procSymbol);
    
    if (_scanner->Peek() == tLBracketRound)
    {
      Consume(tLBracketRound);
      /*
      while (true)
      {
        GetParams(_scanner, typeManager, procSymbol);
        if (_scanner->Peek() != tSemicolon)
        {
          break;
        }
        else
        {
          Consume(tSemicolon);
        }
      }*/
      GetParams(_scanner, typeManager, procSymbol);
      Consume(tRBracketRound);
    }
    Consume(tSemicolon);
    
    Consume(tVar);
    while (true)
    {
      GetVariables(_scanner, procScope, typeManager);
      Consume(tSemicolon);
      if (_scanner->Peek().GetType() != tId)
      {
        break;
      }
    }
    
    Consume(tBegin);
    
    CAstStatement* procStatSeq = NULL;
    procStatSeq = statSequence(procScope);
    
    Consume(tEnd);
    procScope->SetStatementSequence(procStatSeq);
    
    CToken* procNameCheck = NULL;
    Consume(tId, procNameCheck);
    if (procNameCheck->GetValue() != procName->GetValue())
    {
      SetError(procNameCheck, "Procedure name mismatch.");
    }
    Consume(tSemicolon);
  }
  
  Consume(tBegin);
  printf("Got begin keyword!\n");
  //CAstStatement* statseq = statSequence(m);
  
  Consume(tEnd);
  CToken* module_id_check = new CToken();
  Consume(tId, module_id_check);

  if (module_id->GetValue() != module_id_check->GetValue())
  {
    SetError(t, "module name mismatch.");
  }
  Consume(tDot);
  
  return m;
}

CType* CParser::GetOneTypeParams (CScanner* _scanner, CTypeManager* _tm, CSymProc* _ps, int idx)
{
  CToken* paramId = new CToken();
  Consume(tId, paramId);
  
  CType* paramType = NULL;
  
  if (_scanner->Peek().GetType() == tComma)
  {
    Consume(tComma);
    paramType = GetOneTypeParams(_scanner, _tm, _ps, i+1);
    _ps->AddParam(new CSymParam(i, paramId->GetValue(), paramType));
  }
  else
  {
    Consume(tColon);
    paramType = type(_tm, true);
    if (!paramType->IsBoolean() && !paramType->IsChar() && !paramType->IsInt() && !paramType->IsArray() && !paramType->IsPointer())
    {
      printf("Type error!\n");
    }
    _ps->AddParam(new CSymParam(i, paramId->GetValue(), paramType));
  }
  return paramType;
}

CType* CParser::GetParams (CScanner* _scanner, CTypeManager* _tm, CSymProc* _ps)
{
  CType* oneTypeResult = GetOneTypeParams(_scanner, _tm, _ps, 0);
  if (_scanner->Peek().GetType() == tSemicolon)
  {
    Consume(tSemicolon);
    GetParams(_scanner, _tm, _ps);
  }
  else
  {
    return oneTypeResult;
  }
}

CType* CParser::GetVariables (CScanner* _scanner, CAstScope* s, CTypeManager* _tm)
{
  printf("In GetVariables function!\n");
  cout << "Current scanner peek : " << _scanner->Peek().GetValue() << endl;
  CToken* varId = new CToken();
  Consume(tId, varId);
  
  CType* identType = NULL;
  
  if (_scanner->Peek().GetType() == tComma)
  {
    Consume(tComma);
    identType = GetVariables(_scanner, s, _tm);
    s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType));
  }
  else
  {
    Consume(tColon);
    identType = type(_tm, false);
    printf("Got type!\n");
    if (!identType->IsBoolean() && !identType->IsChar() && !identType->IsInt())
    {
      printf("Type error!\n");
    }
    s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType));
  }
  return identType;
}

CType* CParser::GenerateArrayType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  //Consume(tLBracket);
  CToken* elemCount = NULL;
  Consume(tNum, elemCount);
  Consume(tRBracket);
  char* endPtr = 0;
  if (_scanner->Peek().GetType() == tLBracket)
  {
    Consume(tLBracket);
    return _tm->GetArray(strtol(elemCount->GetValue().c_str(), &endPtr, 10), GenerateArrayType(_scanner, _tm));
  }
  else
  {
    return _tm->GetArray(strtol(elemCount->GetValue().c_str(), &endPtr, 10), _baseType);
  }
}

CType* CParser::GeneratePointerType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  if (_scanner->Peek().GetType() == tLBracket)
  {
    Consume(tLBracket);
    return _tm->GetPointer(GeneratePointerType(_scanner, _tm, _baseType));
  }
  else
  {
    return _tm->GetPointer(_baseType);
  }
}

CType* CParser::type(CTypeManager* _tm, bool _isParam)
{
  //
  // type                = basetype | type "[" [ number ] "]".
  //
  if (_scanner->Peek().GetType() == tBoolean)
  {
    Consume(tBoolean);
    if (_scanner->Peek().GetType() == tLBracket)
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket)
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetBool());
      }
      else
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetBool());
      }
    }
    else
    {
      return (CType*)_tm->GetBool();
    }
  }
  else if (_scanner->Peek().GetType() == tChar)
  {
    Consume(tChar);
    if (_scanner->Peek().GetType() == tLBracket)
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket)
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetChar());
      }
      else
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetChar());
      }
    }
    else
    {
      return (CType*)_tm->GetChar();
    }
  }
  else if (_scanner->Peek().GetType() == tInteger)
  {
    Consume(tInteger);
    if (_scanner->Peek().GetType() == tLBracket)
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket)
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetInt());
      }
      else
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetInt());
      }
    }
    else
    {
      return (CType*)_tm->GetInt();
    }
  }
  else 
  {
    return NULL;
  }
}

CAstStatement* CParser::statSequence(CAstScope *s)
{
  //
  // statSequence ::= [ statement { ";" statement } ].
  // statement ::= assignment.
  // FIRST(statSequence) = { tNum }
  // FOLLOW(statSequence) = { tDot }
  //
  // statement           = assignment | subroutineCall | ifStatement | whileStatement | returnStatement.
  // statSequence        = [ statement { ";" statement } ].
  // FIRST(statSequence) = epsilon | ident | "if" | "while" | "return"
  //      (CAUTION : ident is from both 'assignment' and 'subroutineCall')
  // FOLLOW(statSequence) = "end" | "else"

  CAstStatement *head = NULL;
  
  CTypeManager* typeManager = CTypeManager::Get();

  EToken statSeqFirstType = _scanner->Peek().GetType();
  
  if (statSeqFirstType != tEnd && statSeqFirstType != tElse)
  {
    CAstStatement* tail = NULL;
    
    while(!_abort)
    {
      EToken statFirstType = _scanner->Peek().GetType();
      CAstStatement* st = NULL;
      
      if (statFirstType == tId)
      {
        CToken* commonFirst = NULL;
        Consume(tId, commonFirst);
        
        if (_scanner->Peek() == tAssign)
        {
          st = assignment(s, commonFirst);
        }
        else if (_scanner->Peek() == tLBracketRound)
        {
          st = subroutineCall(s, commonFirst, typeManager);
        }
        else
        {
          SetError(_scanner->Peek(), "Call for function/procedure or assignment expected.");
        }
      }
      else if (statFirstType == tIf)
      {
        st = ifStatement(s);
      }
      else if (statFirstType == tWhile)
      {
        st = whileStatement(s);
      }
      else if (statFirstType == tReturn)
      {
        st = returnStatement(s);
      }
      else
      {
        SetError(_scanner->Peek(), "Statement expected.");
      }
      
      assert(st != NULL);
      if (head == NULL)
      {
        head = st;
      }
      else
      {
        tail->SetNext(st);
      }
      tail = st;
      
      statSeqFirstType = _scanner->Peek().GetType();
      if (statSeqFirstType == tEnd || statSeqFirstType == tElse)
      {
        break;
      }
      Consume(tSemicolon);
    }
  }
  return head;
}

CAstStatCall* CParser::subroutineCall(CAstScope* s, CToken* prevToken, CTypeManager* _tm)
{
  //
  // subroutineCall      = ident "(" [ expression {"," expression} ] ")".
  //
  CSymbol* funcSymbol = s->GetSymbolTable()->FindSymbol(prevToken->GetName());
  //CType* funcDataType = funcSymbol->GetDataType()
  CAstFunctionCall* funcCall = new CAstFunctionCall(prevToken, funcSymbol);
  
  AddArguments(s, _scanner, _tm, funcCall);
  
  return new CAstStatCall(prevToken, funcCall);
}

void CParser::AddArguments(CAstScope* s, CScanner* _scanner, CTypeManager* _tm, CAstFunctionCall* _fc)
{
  Comsume(tLBracketRound);
  
  if (_scanner->Peek() == tRBracketRound)
  {
    return;
  }
  else
  {
    CAstExpression* exp = expression(s);
    _fc->AddArg(exp);
    while(_scanner->Peek().GetType() == tComma)
    {
      Consume(tComma);
      exp = expression(s);
      _fc->AddArg(exp);
    }
  }
}

CAstStatIf* ifStatement(CAstScope* s)
{
  //
  // ifStatement         = "if" "(" expression ")" "then" statSequence [ "else" statSequence ] "end".
  //
  // TODO: Implement ifStatement.
  return NULL;
}

CAstStatWhile* whileStatement(CAstScope* s)
{
  //
  // whileStatement      = "while" "(" expression ")" "do" statSequence "end".
  //
  // TODO: Implement whileStatement.
  return NULL;
}

CAstStatReturn* returnStatement(CAstScope* s)
{
  //
  // returnStatement     = "return" [ expression ].
  //
  // TODO: Implement returnStatement.
  return NULL;
}

CAstStatAssign* CParser::assignment(CAstScope *s, CToken* lhs)
{
  //
  // assignment ::= number ":=" expression.
  //
  // assignment          = qualident ":=" expression.
  //
  // qualident is either an (multi-dimensional)array or basetype identifier.
  //
  CToken t;
  CSymbol* symbol = s->GetSymbolTable()->FindSymbol(lhs->GetName());

  if (_scanner->Peek()->GetType() == tLBracket)
  {
    CAstArrayDesignator* qualid = CAstArrayDesignator(lhs, symbol);
    while(_scanner->Peek() == tLBracket)
    {
      Consume(tLBracket);
      CAstExpression* idxExp = expression(s);
      qualid->AddIndex(idxExp);
      Consume(tRBracket);
    }
    qualid->IndicesComplete();
    
    Consume(tAssign, &t);
    
    CAstExpression* rhs = expression(s);
    
    return new CAstStatAssign(t, qualid, rhs);
  }
  else
  {
    CAstDesignator* id = CAstDesignator(lhs, symbol);
    
    Consume(tAssign, &t);
    
    CAstExpression *rhs = expression(s);
    
    return new CAstStatAssign(t, id, rhs);
  }
}

CAstExpression* CParser::expression(CAstScope* s)
{
  //
  // expression ::= simpleexpr [ relOp simpleexpression ].
  //
  // expression          = simpleexpr [ relOp simpleexpr ].
  //
  CToken t;
  EOperation relop;
  CAstExpression *left = NULL, *right = NULL;

  left = simpleexpr(s);

  if (_scanner->Peek().GetType() == tRelOp) 
  {
    Consume(tRelOp, &t);
    right = simpleexpr(s);

    if (t.GetValue() == "=")
    {
      relop = opEqual;
    }
    else if (t.GetValue() == "#")
    {
      relop = opNotEqual;
    }
    else if (t.GetValue() == "<")
    {
      relop = opLessThan;
    }
    else if (t.GetValue() == "<=")
    {
      relop = opLessEqual;
    }
    else if (t.GetValue() == ">")
    {
      relop = opBiggerThan;
    }
    else if (t.GetValue() == ">=")
    {
      relop = opBiggerEqual;
    }
    else 
    {
      SetError(t, "invalid relation.");
    }

    return new CAstBinaryOp(t, relop, left, right);
  } 
  else 
  {
    return left;
  }
}

CAstExpression* CParser::simpleexpr(CAstScope *s)
{
  //
  // simpleexpr ::= term { termOp term }.
  //
  // simpleexpr          = ["+"|"-"] term { termOp term }.
  //
  CAstExpression *n = NULL;

  n = term(s);

  while (_scanner->Peek().GetType() == tTerm) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tTerm, &t);

    r = term(s);

    n = new CAstBinaryOp(t, t.GetValue() == "+" ? opAdd : opSub, l, r);
  }


  return n;
}

CAstExpression* CParser::term(CAstScope *s)
{
  //
  // term ::= factor { ("*"|"/") factor }.
  //
  CAstExpression *n = NULL;

  n = factor(s);

  EToken tt = _scanner->Peek().GetType();

  while ((tt == tFact)) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tFact, &t);

    r = factor(s);

    n = new CAstBinaryOp(t, t.GetValue() == "*" ? opMul : opDiv, l, r);

    tt = _scanner->Peek().GetType();
  }

  return n;
}

CAstExpression* CParser::factor(CAstScope *s)
{
  //
  // factor ::= number | "(" expression ")"
  //
  // FIRST(factor) = { tNum, tLBrak }
  //

  CToken t;
  EToken tt = _scanner->Peek().GetType();
  CAstExpression *unary = NULL, *n = NULL;

  switch (tt) {
    // factor ::= number
    case tNum:
      n = number();
      break;

    // factor ::= "(" expression ")"
    case tLBracketRound:
      Consume(tLBracketRound);
      n = expression(s);
      Consume(tRBracketRound);
      break;

    default:
      cout << "got " << _scanner->Peek() << endl;
      SetError(_scanner->Peek(), "factor expected.");
      break;
  }

  return n;
}

CAstConstant* CParser::number(void)
{
  //
  // number ::= digit { digit }.
  //
  // "digit { digit }" is scanned as one token (tNum)
  //

  CToken t;

  Consume(tNum, &t);

  errno = 0;
  long long v = strtoll(t.GetValue().c_str(), NULL, 10);
  if (errno != 0) SetError(t, "invalid number.");

  return new CAstConstant(t, CTypeManager::Get()->GetInt(), v);
}