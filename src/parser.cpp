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
  
  CSymtab moduleSymTab = new CSymtab();
  
  CToken t; // For error indication.
  Consume(tModule); 
  
  CToken* module_id = new CToken(); // Module name.
  Consume(tId, module_id);
  Consume(tSemicolon);
  
  CAstModule* m = new CAstModule(t, module_id->GetValue()); // Scope for module.
  
  CTypeManager* typeManager = CTypeManager::Get(); // Typemanager to deal with types.
  
  CToken checkIfVar = _scanner->Peek(); // Check if there are global variables.
  if (checkIfVar.GetType() == tVar) // Global variable exists.
  {
    Consume(tVar);
   
    while (true)
    {
      GetVariables(_scanner, m, typeManager); // Get one type of variables at a time.
      printf("End get variables.\n");
      cout << "Next token is : " << _scanner->Peek().GetValue() << endl;
      Consume(tSemicolon); // Semicolon separates one type of variables from other ones.
      printf("Got semicolon of end of var decl.\n");
      if (_scanner->Peek().GetType() != tId)
      {
        break;
      }
    }
  }
  // TODO: Support for multiple functions.
  while (_scanner->Peek() == tProcedure) // Procedure definitions. May be multiple of them.
  {
    Consume(tProcedure);
    
    CToken* procName = new CToken(); // For procedure name.
    Consume(tId, procName);
    
    CSymProc* procSymbol = new CSymProc(procName->GetValue(), NULL); // Symbol for procedure. Procedure returns NULL.
    m->GetSymbolTable()->AddSymbol(procSymbol); // Add procedure symbol to module's symbol table.
    
    CAstProcedure* procScope = new CAstProcedure(procName, procName->GetValue(), m, procSymbol); // Scope for procedure.
    
    if (_scanner->Peek() == tLBracketRound) // When procedure has parameters.
    {
      Consume(tLBracketRound);
      
      GetParams(_scanner, typeManager, procSymbol); // Get parameters for procedure.
      
      Consume(tRBracketRound);
    }
    Consume(tSemicolon); 
    
    if (_scanner->Peek() == tVar) // When procedure has its local variables.
    {
      Consume(tVar);
      while (true) // Iterates until there is no variable to declare.
      {
        GetVariables(_scanner, procScope, typeManager); // Get one type of variables.
        Consume(tSemicolon);
        if (_scanner->Peek().GetType() != tId) // If there is no more, stop.
        {
          break;
        }
      }
    }
    
    Consume(tBegin);
    
    CAstStatement* procStatSeq = NULL;
    procStatSeq = statSequence(procScope); // Get sequence of statements for this procedure.
    
    Consume(tEnd);
    procScope->SetStatementSequence(procStatSeq); // Set procedure's statement sequence.
    
    CToken* procNameCheck = NULL;
    Consume(tId, procNameCheck); // Ending name of procedure. Must match starting name.
    if (procNameCheck->GetValue() != procName->GetValue()) // Check if name matches.
    {
      SetError(procNameCheck, "Procedure name mismatch.");
    }
    Consume(tSemicolon);
  }
  
  Consume(tBegin);
  printf("Got begin keyword!\n");
  
  // TODO: Support for statements in module.
  //CAstStatement* statseq = statSequence(m);
  
  Consume(tEnd);
  CToken* module_id_check = new CToken();
  Consume(tId, module_id_check); // Ending name of module. Must match starting name.

  if (module_id->GetValue() != module_id_check->GetValue()) // Check if name matches.
  {
    SetError(t, "module name mismatch.");
  }
  Consume(tDot);
  
  return m;
}

CType* CParser::GetOneTypeParams (CScanner* _scanner, CTypeManager* _tm, CSymProc* _ps, int idx)
{
  CToken* paramId = new CToken();
  Consume(tId, paramId); // Get identifier for parameter.
  
  CType* paramType = NULL;
  
  if (_scanner->Peek().GetType() == tComma) // When there are more identifier(s) of same type.
  {
    Consume(tComma);
    paramType = GetOneTypeParams(_scanner, _tm, _ps, i+1); // Recursive call.
    _ps->AddParam(new CSymParam(i, paramId->GetValue(), paramType)); // When above recursive call returns type, add parameter to procedure symbol. 
  }
  else // When there are no more identifier(s) of same type.
  {
    Consume(tColon);
    paramType = type(_tm, true); // Set Parameter type.
    if (!paramType->IsBoolean() && !paramType->IsChar() && !paramType->IsInt() && !paramType->IsArray() && !paramType->IsPointer()) // Check for type.
    {
      printf("Type error!\n");
    }
    _ps->AddParam(new CSymParam(i, paramId->GetValue(), paramType)); // Add parameter to procedure symbol.
  }
  return paramType; // Return the type for recursive call.
}

CType* CParser::GetParams (CScanner* _scanner, CTypeManager* _tm, CSymProc* _ps)
{
  CType* oneTypeResult = GetOneTypeParams(_scanner, _tm, _ps, 0); // Adds one type of parameters.
  if (_scanner->Peek().GetType() == tSemicolon) // When there are more variables.
  {
    Consume(tSemicolon);
    GetParams(_scanner, _tm, _ps); // Recursive call.
  }
  else
  {
    return oneTypeResult; // Return the type for recursive call.
  }
}

CType* CParser::GetVariables (CScanner* _scanner, CAstScope* s, CTypeManager* _tm)
{
  printf("In GetVariables function!\n");
  cout << "Current scanner peek : " << _scanner->Peek().GetValue() << endl;
  CToken* varId = new CToken();
  Consume(tId, varId); // Gets identifier for variable.
  
  CType* identType = NULL;
  
  if (_scanner->Peek().GetType() == tComma) // When there are more variable of same type.
  {
    Consume(tComma);
    identType = GetVariables(_scanner, s, _tm); // Recursive call.
    s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType)); // When above recursive call gives type, add variable to scope's symbol table. 
  }
  else // When there are no more variable of same type.
  {
    Consume(tColon);
    identType = type(_tm, false); // Get type.
    printf("Got type!\n");
    if (!identType->IsBoolean() && !identType->IsChar() && !identType->IsInt() && !paramType->IsArray() && !paramType->IsPointer()) // Check for type.
    {
      printf("Type error!\n");
    }
    s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType)); // Add variable to scope's symbol table.
  }
  return identType; // Return the type for recursive call.
}

CType* CParser::GenerateArrayType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  CToken* elemCount = NULL;
  Consume(tNum, elemCount); // Gets number of element in this dimension.
  Consume(tRBracket);
  char* endPtr = 0; // For string to integer conversion.
  if (_scanner->Peek().GetType() == tLBracket) // When more dimensions exist.
  {
    Consume(tLBracket);
    return _tm->GetArray(strtol(elemCount->GetValue().c_str(), &endPtr, 10), GenerateArrayType(_scanner, _tm)); // Type for this dimension will be array of array by recursive call.
  }
  else // When there are no more dimensions exist. i.e., 1st dimension.
  {
    return _tm->GetArray(strtol(elemCount->GetValue().c_str(), &endPtr, 10), _baseType); // Type of this dimension will be array of _baseType.
  }
}

CType* CParser::GeneratePointerType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  if (_scanner->Peek().GetType() == tLBracket) // When more dimensions exist.
  {
    Consume(tLBracket);
    return _tm->GetPointer(GeneratePointerType(_scanner, _tm, _baseType)); // Type of this dimension will be pointer to pointer by recursive call.
  }
  else // When there are no more dimensions exist.
  {
    return _tm->GetPointer(_baseType); // Type of this dimension will be pointer to _baseType.
  }
}

CType* CParser::type(CTypeManager* _tm, bool _isParam)
{
  //
  // type                = basetype | type "[" [ number ] "]".
  //
  if (_scanner->Peek().GetType() == tBoolean) // Boolean basetype, array or pointer type.
  {
    Consume(tBoolean);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of boolean array or pointer type.
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket) // Boolean pointer type.
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetBool());
      }
      else // Boolean array type.
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetBool());
      }
    }
    else // Boolean basetype.
    {
      return (CType*)_tm->GetBool();
    }
  }
  else if (_scanner->Peek().GetType() == tChar) // Character basetype, array or pointer type.
  {
    Consume(tChar);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of character array or pointer type.
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket) // Character pointer type.
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetChar());
      }
      else // Character array type.
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetChar());
      }
    }
    else // Character basetype.
    {
      return (CType*)_tm->GetChar();
    }
  }
  else if (_scanner->Peek().GetType() == tInteger) // Integer basetype, array or pointer type.
  {
    Consume(tInteger);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of integer array or pointer type.
    {
      Consume(tLBracket);
      if (_scanner->Peek().GetType() == tRBracket) // Integer pointer type.
      {
        return (CType*)GeneratePointerType(_scanner, _tm, (CType*)_tm->GetInt());
      }
      else // Integer array type.
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetInt());
      }
    }
    else // Integer basetype.
    {
      return (CType*)_tm->GetInt();
    }
  }
  else // Invalid type.
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

  CAstStatement *head = NULL; // Head of statement sequence. Statements are accessed as linked list.
  
  CTypeManager* typeManager = CTypeManager::Get(); // Global type manager.

  EToken statSeqFirstType = _scanner->Peek().GetType(); // Token type to check if statement is empty.
  
  if (statSeqFirstType != tEnd && statSeqFirstType != tElse) // When statement is not empty.
  {
    CAstStatement* tail = NULL; // Tail of statement sequence.
    
    while(!_abort) // Repeat until error.
    {
      EToken statFirstType = _scanner->Peek().GetType(); // Token type to check what type of statement is being processed.
      CAstStatement* st = NULL;
      
      if (statFirstType == tId) // Assignment or subroutineCall.
      {
        CToken* commonFirst = NULL;
        Consume(tId, commonFirst); // Consume common FIRST.
        
        if (_scanner->Peek() == tAssign) // Case of assignment.
        {
          st = assignment(s, commonFirst);
        }
        else if (_scanner->Peek() == tLBracketRound) // Case of subroutineCall.
        {
          st = subroutineCall(s, commonFirst, typeManager);
        }
        else // Error.
        {
          SetError(_scanner->Peek(), "Call for function/procedure or assignment expected.");
        }
      }
      else if (statFirstType == tIf) // Case of ifStatement.
      {
        st = ifStatement(s);
      }
      else if (statFirstType == tWhile) // Case of whileStatement.
      {
        st = whileStatement(s);
      }
      else if (statFirstType == tReturn) // Case of returnStatement.
      {
        st = returnStatement(s);
      }
      else // Error.
      {
        SetError(_scanner->Peek(), "Statement expected.");
      }
      
      assert(st != NULL);
      if (head == NULL) // When first statement is processed.
      {
        head = st;
      }
      else // When not first.
      {
        tail->SetNext(st);
      }
      tail = st;
      
      statSeqFirstType = _scanner->Peek().GetType(); // Ready for next statement.
      if (statSeqFirstType == tEnd || statSeqFirstType == tElse) // When FOLLOW of statSequence is met. Indicates end of sequence.
      {
        break;
      }
      Consume(tSemicolon); // Repeat processing statement.
    }
  }
  return head; // Return the first statement of sequence.
}

CAstStatCall* CParser::subroutineCall(CAstScope* s, CToken* prevToken, CTypeManager* _tm)
{
  //
  // subroutineCall      = ident "(" [ expression {"," expression} ] ")".
  //
  CSymbol* funcSymbol = s->GetSymbolTable()->FindSymbol(prevToken->GetName()); // Find symbol for procedure/function.
  //CType* funcDataType = funcSymbol->GetDataType()
  CAstFunctionCall* funcCall = new CAstFunctionCall(prevToken, funcSymbol); // Make functionCall AST node.
  
  AddArguments(s, _scanner, _tm, funcCall); // Add arguments to procedure/function.
  
  return new CAstStatCall(prevToken, funcCall);
}

void CParser::AddArguments(CAstScope* s, CScanner* _scanner, CTypeManager* _tm, CAstFunctionCall* _fc)
{
  Comsume(tLBracketRound);
  
  if (_scanner->Peek() == tRBracketRound) // No argument to add.
  {
    return;
  }
  else // Argument(s) exist(s).
  {
    CAstExpression* exp = expression(s); // Get argument.
    _fc->AddArg(exp); // Add argument to functionCall.
    while(_scanner->Peek().GetType() == tComma) // Until there are no more argument left, iterate.
    {
      Consume(tComma);
      exp = expression(s); // Get argument.
      _fc->AddArg(exp); // Add argument to functionCall.
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
  CSymbol* symbol = s->GetSymbolTable()->FindSymbol(lhs->GetName()); // Fins symbol for LHS, which is qualident or ident.

  if (_scanner->Peek()->GetType() == tLBracket) // When LHS is qualident.
  {
    CAstArrayDesignator* qualid = CAstArrayDesignator(lhs, symbol); // Make qualident object.
    while(_scanner->Peek() == tLBracket) // Gets all indices.
    {
      Consume(tLBracket);
      CAstExpression* idxExp = expression(s); // Get index.
      qualid->AddIndex(idxExp); // Set index of qualident.
      Consume(tRBracket);
    }
    qualid->IndicesComplete(); // Declare that indexing is finished.
    
    Consume(tAssign, &t);
    
    CAstExpression* rhs = expression(s); // Gets RHS.
    
    return new CAstStatAssign(t, qualid, rhs);
  }
  else // When LHS is ident.
  {
    CAstDesignator* id = CAstDesignator(lhs, symbol); // Make ident object.
    
    Consume(tAssign, &t);
    
    CAstExpression *rhs = expression(s); // Gets RHS.
    
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

  if (_scanner->Peek().GetType() == tRelOp) // When form of simpleexpr relOp simpleexpr.
  {
    Consume(tRelOp, &t);
    right = simpleexpr(s);

    if (t.GetValue() == "=") // Equality.
    {
      relop = opEqual;
    }
    else if (t.GetValue() == "#") // Inequality.
    {
      relop = opNotEqual;
    }
    else if (t.GetValue() == "<") // Less than.
    {
      relop = opLessThan;
    }
    else if (t.GetValue() == "<=") // Less than or equal to.
    {
      relop = opLessEqual;
    }
    else if (t.GetValue() == ">") // Greater than.
    {
      relop = opBiggerThan;
    }
    else if (t.GetValue() == ">=") // Greater than or equal to.
    {
      relop = opBiggerEqual;
    }
    else // Invalid relation operator.
    {
      SetError(t, "invalid relation.");
    }

    return new CAstBinaryOp(t, relop, left, right);
  } 
  else // When form of simpleexpr.
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
  
  if (_scanner->Peek().GetValue() == "+")
  {
    CToken* unaryOp = NULL;
    Consume(tTerm, unaryOp);
    n = term(s);
  }
  else if (_scanner->Peek().GetValue() == "-")
  {
    CToken* unaryOp = NULL;
    Consume(tTerm, unaryOp);
    n = new CAstUnaryOp(unaryOp, opNeg, term(s));
  }
  else
  {
    n = term(s);
  }

  while (_scanner->Peek().GetType() == tTerm) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tTerm, &t);

    r = term(s);
    if (t.GetValue() == "+")
    {
      n = new CAstBinaryOp(t, opAdd, l, r);
    }
    else if (t.GetValue() == "-")
    {
      n = new CAstBinaryOp(t, opSub, l, r);
    }
    else
    {
      n = new CAstBinaryOp(t, opOr, l, r);  
    }
  }

  return n;
}

CAstExpression* CParser::term(CAstScope *s)
{
  //
  // term ::= factor { ("*"|"/") factor }.
  //
  // term                = factor { factOp factor }.
  //
  CAstExpression *n = NULL;

  n = factor(s);

  EToken tt = _scanner->Peek().GetType();

  while ((tt == tFact)) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tFact, &t);

    r = factor(s);

    if (t.GetValue() == "*")
    {
      n = new CAstBinaryOp(t, opMul, l, r);
    }
    else if (t.GetValue() == "/");
    {
      n = new CAstBinaryOp(t, opDiv, l, r);
    }
    else
    {
      n = new CAstBinaryOp(t, opAnd, l, r);
    }

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
  // factor              = qualident | number | boolean | char | string | 
  //                       "(" expression ")" | subroutineCall | "!" factor.
  //
  // FIRST(factor) = ident | number | "true" | "false" | char | string | "(" | "!"
  //      (CAUTION : ident is from both 'qualident' and 'subroutineCall')
  //
  // FOLLOW(factor) = "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" |
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