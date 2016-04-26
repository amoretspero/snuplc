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

#include <string.h>

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
  CSymProc* f;
  
  // For info of predefined functions, please refer to data/PredefinedFunctions.txt file.
  
  f = new CSymProc("DIM", tm->GetInt());
  f->AddParam(new CSymParam(0, "array", tm->GetPointer(tm->GetNull())));
  f->AddParam(new CSymParam(1, "dim", tm->GetInt()));
  s->AddSymbol(f);
  
  f = new CSymProc("DOFS", tm->GetInt());
  f->AddParam(new CSymParam(0, "array", tm->GetPointer(tm->GetNull())));
  s->AddSymbol(f);
  
  f = new CSymProc("ReadInt", tm->GetInt());
  s->AddSymbol(f);
  
  f = new CSymProc("WriteInt", tm->GetNull());
  f->AddParam(new CSymParam(0, "i", tm->GetInt()));
  s->AddSymbol(f);
  
  f = new CSymProc("WriteChar", tm->GetNull());
  f->AddParam(new CSymParam(0, "c", tm->GetChar()));
  s->AddSymbol(f);
  
  f = new CSymProc("WriteStr", tm->GetNull());
  f->AddParam(new CSymParam(0, "str", tm->GetPointer(tm->GetArray(-1, tm->GetChar()))));
  s->AddSymbol(f);
  
  f = new CSymProc("WriteLn", tm->GetNull());
  s->AddSymbol(f);
}

CAstModule* CParser::module(void)
{
  //
  // module              = "module" ident ";" varDeclaration { subroutineDecl } "begin" 
  //                       statSequence "end" ident ".".
  //
  
  CSymtab moduleSymTab = new CSymtab(); // New symbol table for initialization of module's symbol table.
  
  CToken t; // For error indication.
  Consume(tModule); 
  
  CToken* module_id = new CToken(); // Module name.
  Consume(tId, module_id);
  Consume(tSemicolon);
  
  CAstModule* m = new CAstModule(t, module_id->GetValue()); // Scope for module.
  
  CTypeManager* typeManager = CTypeManager::Get(); // Typemanager to deal with types.
  
  InitSymbolTable(m->GetSymbolTable()); // Initialize module's symbol table.
  
  CToken checkIfVar = _scanner->Peek(); // Check if there are global variables.
  if (checkIfVar.GetType() == tVar) // Global variable exists.
  {
    Consume(tVar);
   
    while (true)
    {
      vector<CToken*> varVec; // Vector for one type of global variables.
      CType* varType = GetVariables(_scanner, &varVec); // Get one type of global variables and their type.
      
      //cout << "===(DEBUG)===Got global variables, count : " << varVec.size() << endl;
      
      vector<CToken*>::iterator oneTypeIter = varVec.begin();
      //cout << "===(DEBUG)===Got begin of varVec, at module." << endl;
      while(oneTypeIter != varVec.end() && varVec.size() > 0) // Iterate through vector and add variables.
      {
        if (m->GetSymbolTable() == NULL)
        {
          //cout << "===(DEBUG)===Module symboltable is NULL." << endl;
        }
        //cout << "===(DEBUG)===In variable adding loop. token value is : " << (*oneTypeIter)->GetValue() << endl;
        bool addVarRes = m->GetSymbolTable()->AddSymbol(m->CreateVar((*oneTypeIter)->GetValue(), varType)); // Add variable to symbol table.
        
        if (!addVarRes) // If adding fails, i.e. there are already variable with same name, throw error.
        {
          SetError((*oneTypeIter), "duplicate variable declaration '" + (*oneTypeIter)->GetValue() + "'.");
        }
        oneTypeIter++;
      }
      //GetVariables(_scanner, m, typeManager); // Get one type of variables at a time.
      //printf("End get variables.\n");
      //cout << "===(DEBUG)===Next token is : " << _scanner->Peek().GetValue() << endl;
      Consume(tSemicolon); // Semicolon separates one type of variables from other ones.
      //cout << "===(DEBUG)===Got semicolon of end of var decl." << endl;
      //cout << "===(DEBUG)===Next token is : " << _scanner->Peek().GetValue() << endl;
      if (_scanner->Peek().GetType() != tId) // If there are no more variables to add, end loop.
      {
        break;
      }
    }
  }

  // Part for processing multiple procedure/function. ===START===
  while (_scanner->Peek().GetType() == tProcedure || _scanner->Peek().GetType() == tFunction) // Procedure/Function definitions. May be multiple of them.
  {
    if (_scanner->Peek().GetType() == tProcedure) // Procedure case.
    {
      Consume(tProcedure);
      //cout << "===(DEBUG)===Now consumed tProcedure. Next token is : " << _scanner->Peek().GetValue() << endl;
      CToken* procName = new CToken(); // For procedure name.
      //cout << "===(DEBUG)===Now make CToken for procedure name. Next token is : " << _scanner->Peek().GetValue() << endl;
      Consume(tId, procName);
      //cout << "===(DEBUG)===Now consumed tId. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      /*
      const CSymProc* procNameDupCheck = dynamic_cast<const CSymProc*>(m->GetSymbolTable()->FindSymbol(procName->GetValue())); // Find whether procedure name is duplicated.
      if (procNameDupCheck != NULL)
      {
        SetError(procName, "duplicate procedure/function declaration '" + procName->GetValue() + "'.");
      }*/
      const CSymbol* procNameDupCheck = m->GetSymbolTable()->FindSymbol(procName->GetValue()); // Check if there is already procedure/function/variable with same name.
      if (procNameDupCheck != NULL) // If there is, throw error.
      {
        SetError(procName, "duplicate procedure/function declaration '" + procName->GetValue() + "'.");
      }
      
      vector<vector<CSymParam*> > parameterVector; // Vector for temporarily containing parameters.
      
      if (_scanner->Peek().GetType() == tLBracketRound) // When procedure has parameters.
      {
        Consume(tLBracketRound);
        
        if (_scanner->Peek().GetType() != tRBracketRound) // When procedure has parameters, get them. Duplication check is done in GetParams function.
        {
          GetParams(_scanner, typeManager, &parameterVector, 0); // Get parameters for procedure.
        }
        
        Consume(tRBracketRound);
      }
      Consume(tSemicolon); 
      //cout << "===(DEBUG)===Now consumed all parameters. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CSymProc* procSymbol = new CSymProc(procName->GetValue(), typeManager->GetNull()); // Symbol for procedure. Procedure returns NULL.
      
      //vector<vector<CSymParam*> > symbolVector = parameterVector;
      
      vector<vector<CSymParam*> >::iterator iter = parameterVector.begin();
      
      while(iter != parameterVector.end() && parameterVector.size() > 0) // Add symbols to procedure symbol.
      {
        vector<CSymParam*> oneTypeParamVec = *iter;
        vector<CSymParam*>::reverse_iterator oneTypeIter = oneTypeParamVec.rbegin();
        while(oneTypeIter != oneTypeParamVec.rend() && oneTypeParamVec.size() > 0)
        {
          CSymParam* param = *oneTypeIter;
          
          procSymbol->AddParam(param);
          //cout << "===(DEBUG)===Now added parameter <" << param->GetName() << "> to procedure symbol." << endl;
          //oneTypeParamVec.pop_back();
          oneTypeIter++;
        }
        //parameterVector.pop_back();
        iter++;
      }
      
      //cout << "===(DEBUG)===Now added all parameters to procedure symbol. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CAstProcedure* procScope = new CAstProcedure(procName, procName->GetValue(), m, procSymbol); // Scope for procedure.
      
      iter = parameterVector.begin();
      
      while(iter != parameterVector.end() && parameterVector.size() > 0) // Add symbols to symbol table of procedure.
      {
        vector<CSymParam*> oneTypeParamVec = *iter;
        vector<CSymParam*>::reverse_iterator oneTypeIter = oneTypeParamVec.rbegin();
        while(oneTypeIter != oneTypeParamVec.rend() && oneTypeParamVec.size() > 0)
        {
          CSymParam* param = *oneTypeIter;
          procScope->GetSymbolTable()->AddSymbol(param);
          //cout << "===(DEBUG)===Now added parameter <" << param->GetName() << "> to procedure scope." << endl;
          //oneTypeParamVec.pop_back();
          oneTypeIter++;
        }
        //symbolVector.pop_back();
        iter++;
      }
      
      //cout << "===(DEBUG)===Now added all parameters to procedure scope. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      m->GetSymbolTable()->AddSymbol(procSymbol); // Add procedure symbol to module's symbol table.
      
      
      if (_scanner->Peek().GetType() == tVar) // When procedure has its local variables.
      {
        Consume(tVar);
        while (true) // Iterates until there is no variable to declare.
        {
          vector<CToken*> varVec;
          //GetVariables(_scanner, procScope, typeManager); // Get one type of variables.
          CType* varType = GetVariables(_scanner, &varVec); // Get one type of variables.
          
          vector<CToken*>::iterator oneTypeIter = varVec.begin();
          while(oneTypeIter != varVec.end() && varVec.size() > 0)
          {
            bool addVarRes = procScope->GetSymbolTable()->AddSymbol(procScope->CreateVar((*oneTypeIter)->GetValue(), varType)); // Add variable to procedure scope.
            if (!addVarRes) // Check for variable duplication.
            {
              SetError(*oneTypeIter, "duplicate variable declaration '" + (*oneTypeIter)->GetValue() + "'.");
            }
            oneTypeIter++;
          }
          
          Consume(tSemicolon);
          if (_scanner->Peek().GetType() != tId) // If there is no more, stop.
          {
            break;
          }
        }
      }
      
      //cout << "===(DEBUG)===Now added all local variables for procedure. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      //vector<CSymbol*> procsymbols = procScope->GetSymbolTable()->GetSymbols();
      //vector<CSymbol*>::iterator procSymIter = procsymbols.begin();
      //while(procSymIter != procsymbols.end() && procsymbols.size() > 0)
      //{
        //cout << "===(DEBUG)===Current scope's Variable/Param name : " << (*procSymIter)->GetName() << endl;
        //procSymIter++;
      //}
      
      Consume(tBegin);
      
      CAstStatement* procStatSeq = NULL;
      procStatSeq = statSequence(procScope); // Get sequence of statements for this procedure.
      
      //cout << "===(DEBUG)===Now got all statements for procedure. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      Consume(tEnd);
      procScope->SetStatementSequence(procStatSeq); // Set procedure's statement sequence.
      
      //cout << "===(DEBUG)===Now added statement sequence for procedure. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CToken* procNameCheck = new CToken();
      Consume(tId, procNameCheck); // Ending name of procedure. Must match starting name.
      //cout << "===(DEBUG)===Now checking name. procName: " << procName->GetValue() << ", procNameCheck: " << procNameCheck->GetValue() << endl;
      if (procNameCheck->GetValue() != procName->GetValue()) // Check if name matches.
      {
        SetError(procNameCheck, "procedure/function identifier mismatch ('"+procName->GetValue()+"' != '"+procNameCheck->GetValue()+"').");
      }
      Consume(tSemicolon);
    }
    else // Function case.
    {
      Consume(tFunction); // Function case.
      //cout << "===(DEBUG)===Now consumed tFunction. Next token is : " << _scanner->Peek().GetValue() << endl;
      CToken* funcName = new CToken(); // For function name.
      //cout << "===(DEBUG)===Now make CToken for procedure name. Next token is : " << _scanner->Peek().GetValue() << endl;
      Consume(tId, funcName);
      //cout << "===(DEBUG)===Now consumed tId. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      /*
      const CSymProc* funcNameDupCheck = dynamic_cast<const CSymProc*>(m->GetSymbolTable()->FindSymbol(funcName->GetValue())); // Find whether function is duplicated.
      if (funcNameDupCheck != NULL)
      {
        SetError(funcName, "duplicate procedure/function declaration '" + funcName->GetValue() + "'.");
      }
      */
      const CSymbol* funcNameDupCheck = m->GetSymbolTable()->FindSymbol(funcName->GetValue()); // Check if there is already procedure/function/variable with same name.
      if (funcNameDupCheck != NULL) // If there is, throw error.
      {
        SetError(funcName, "duplicate procedure/function declaration '" + funcName->GetValue() + "'.");
      }
      
      vector<vector<CSymParam*> > parameterVector; // Vector for temporarily containing parameters.
      
      if (_scanner->Peek().GetType() == tLBracketRound) // When function has parameters.
      {
        Consume(tLBracketRound);
        
        if (_scanner->Peek().GetType() != tRBracketRound) // When function has parameters, get them.
        {
          GetParams(_scanner, typeManager, &parameterVector, 0); // Get parameters for function. Duplication check is done in GetParams() function.
        }
        
        Consume(tRBracketRound);
      }
      Consume(tColon);
      //cout << "===(DEBUG)===Now consumed all parameters. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CType* funcReturnType = type(typeManager, false); // Gets return type of function.
      Consume(tSemicolon);
      //cout << "===(DEBUG)===Now got return type for function. Next token is : " <<_scanner->Peek().GetValue() << endl;
      
      CSymProc* funcSymbol = new CSymProc(funcName->GetValue(), funcReturnType); // Symbol for function. Return type is funcReturnType.
      
      vector<vector<CSymParam*> > symbolVector = parameterVector;
      
      vector<vector<CSymParam*> >::iterator iter = parameterVector.begin();
      
      while(iter != parameterVector.end() && parameterVector.size() > 0) // Add parameters to function symbol.
      {
        vector<CSymParam*> oneTypeParamVec = *iter;
        vector<CSymParam*>::reverse_iterator oneTypeIter = oneTypeParamVec.rbegin();
        while(oneTypeIter != oneTypeParamVec.rend() && oneTypeParamVec.size() > 0)
        {
          CSymParam* param = *oneTypeIter;
          funcSymbol->AddParam(param);
          //cout << "===(DEBUG)===Now added parameter <" << param->GetName() << "> to function symbol." << endl;
          //oneTypeParamVec.pop_back();
          oneTypeIter++;
        }
        //parameterVector.pop_back();
        iter++;
      }
      
      //cout << "===(DEBUG)===Now added all parameters to function symbol. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CAstProcedure* funcScope = new CAstProcedure(funcName, funcName->GetValue(), m, funcSymbol); // Scope for function.
      
      iter = parameterVector.begin();
      
      while(iter != parameterVector.end() && parameterVector.size() > 0)
      {
        vector<CSymParam*> oneTypeParamVec = *iter;
        vector<CSymParam*>::reverse_iterator oneTypeIter = oneTypeParamVec.rbegin();
        while(oneTypeIter != oneTypeParamVec.rend() && oneTypeParamVec.size() > 0)
        {
          CSymParam* param = *oneTypeIter;
          funcScope->GetSymbolTable()->AddSymbol(param);
          //cout << "===(DEBUG)===Now added parameter <" << param->GetName() << "> to function scope." << endl;
          //oneTypeParamVec.pop_back();
          oneTypeIter++;
        }
        //symbolVector.pop_back();
        iter++;
      }
      
      //cout << "===(DEBUG)===Now added all parameters to function scope. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      m->GetSymbolTable()->AddSymbol(funcSymbol); // Add function symbol to module's symbol table.
      
      if (_scanner->Peek().GetType() == tVar) // When function has its local variables.
      {
        Consume(tVar);
        while (true) // Iterates until there is no variable to declare.
        {
          //GetVariables(_scanner, funcScope, typeManager); // Get one type of variables.
          vector<CToken*> varVec; // Vector for getting one type of variables.
          CType* varType = GetVariables(_scanner, &varVec); // Get one type of variables.
          
          vector<CToken*>::iterator oneTypeIter = varVec.begin();
          while(oneTypeIter != varVec.end() && varVec.size() > 0) // Add variables to function scope.
          {
            bool addVarRes = funcScope->GetSymbolTable()->AddSymbol(funcScope->CreateVar((*oneTypeIter)->GetValue(), varType));
            if (!addVarRes) // Check for variable duplication.
            {
              SetError(*oneTypeIter, "duplicate variable declaration '" + (*oneTypeIter)->GetValue() + "'.");
            }
            oneTypeIter++;
          }
          
          Consume(tSemicolon);
          if (_scanner->Peek().GetType() != tId) // If there is no more, stop.
          {
            break;
          }
        }
      }
      
      //cout << "===(DEBUG)===Now added all local variables for function. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      Consume(tBegin);
      
      CAstStatement* funcStatSeq = NULL;
      funcStatSeq = statSequence(funcScope); // Get sequence of statements for this function.
      
      //cout << "===(DEBUG)===Now got all statements for function. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      Consume(tEnd);
      funcScope->SetStatementSequence(funcStatSeq); // Set procedure's statement sequence.
      
      //cout << "===(DEBUG)===Now added statement sequence for function. Next token is : " << _scanner->Peek().GetValue() << endl;
      
      CToken* funcNameCheck = new CToken();
      Consume(tId, funcNameCheck); // Ending name of procedure. Must match starting name.
      //cout << "===(DEBUG)===Now checking name. funcName: " << funcName->GetValue() << ", funcNameCheck: " << funcNameCheck->GetValue() << endl;
      if (funcNameCheck->GetValue() != funcName->GetValue()) // Check if name matches.
      {
        SetError(funcNameCheck, "procedure/function identifier mismatch ('"+funcName->GetValue()+"' != '"+funcNameCheck->GetValue()+"').");
      }
      Consume(tSemicolon);
    }
  }
  // Part for processing multiple procedures/functions. ===END===
  
  Consume(tBegin);
  //printf("Got begin keyword!\n");
  
  CAstStatement* statseq = statSequence(m); // Get statement sequence of module.
  
  Consume(tEnd);
  m->SetStatementSequence(statseq); // Set statement sequence of module.
  
  CToken* module_id_check = new CToken();
  Consume(tId, module_id_check); // Ending name of module. Must match starting name.

  if (module_id->GetValue() != module_id_check->GetValue()) // Check if name matches.
  {
    SetError(module_id_check, "module identifier mismatch ('" + module_id->GetValue() + "' != '" + module_id_check->GetValue() + "').");
  }
  Consume(tDot);
  
  return m;
}

bool CParser::CheckParamDups (vector<vector<CSymParam*> >* paramVec, const string elemToFind)
{
  // Parameters are the first local symbols that will be added to procedure/function scope.
  // So, we only check for duplication in parameters.
  // Local variables will be added after all the parameters are added,
  // therefore parameter-(local)variable duplication will be check when local variables are added.
  bool res = false; // Initialize result at false.
  vector<vector<CSymParam*> >::iterator iter = paramVec->begin();
  while (paramVec->size() > 0 && iter != paramVec->end()) // Iterates through parameters and check for duplication.
  {
    vector<CSymParam*> oneTypeVec = *iter;
    vector<CSymParam*>::iterator oneTypeIter = oneTypeVec.begin();
    while (oneTypeVec.size() > 0 && oneTypeIter != oneTypeVec.end())
    {
      if ((*oneTypeIter)->GetName() == elemToFind) // If duplication occurs, set res to true and return.
      {
        res = true;
        return res;
      }
      oneTypeIter++;
    }
    iter++;
  }
  return res;
}

CType* CParser::GetOneTypeParams (CScanner* _scanner, CTypeManager* _tm, vector<CSymParam*>* paramVec, vector<vector<CSymParam*> >* originVec, int idx)
{
  CToken* paramId = new CToken();
  Consume(tId, paramId); // Get identifier for parameter.
  
  bool checkDupRes = CheckParamDups(originVec, paramId->GetValue()); // Check for parameter duplication.
  if (checkDupRes) // If duplication occurs, throw error.
  {
    SetError(paramId, "duplicate variable declaration '" + paramId->GetValue() + "'.");
  }
  
  //cout << "===(DEBUG)===Got parameter <" << paramId->GetValue() << ">" << endl;
  
  CType* paramType = NULL;
  
  if (_scanner->Peek().GetType() == tComma) // When there are more identifier(s) of same type.
  {
    Consume(tComma);
    paramType = GetOneTypeParams(_scanner, _tm, paramVec, originVec, idx+1); // Recursive call.
    paramVec->push_back(new CSymParam(idx, paramId->GetValue(), paramType)); // When above recursive call returns type, add parameter to procedure symbol.
  }
  else // When there are no more identifier(s) of same type.
  {
    Consume(tColon);
    paramType = type(_tm, true); // Set Parameter type.
    if (!paramType->IsBoolean() && !paramType->IsChar() && !paramType->IsInt() && !paramType->IsArray() && !paramType->IsPointer()) // Check for type.
    {
      cout << "Type error!" << endl;
    }
    paramVec->push_back(new CSymParam(idx, paramId->GetValue(), paramType)); // Add parameter to CSymParam* vector.
  }
  return paramType; // Return the type for recursive call.
}

CType* CParser::GetParams (CScanner* _scanner, CTypeManager* _tm, vector<vector<CSymParam*> >* paramVec, int lastIdx)
{
  paramVec->resize(paramVec->size() + 1); // Add space for one type of parameters.
  CType* oneTypeResult = GetOneTypeParams(_scanner, _tm, &(paramVec->at(paramVec->size() - 1)), paramVec, lastIdx+1); // Adds one type of parameters.
  //cout << "===(DEBUG)===Number of parameters is : " << paramVec->at(paramVec->size() - 1).size() << endl;
  if (_scanner->Peek().GetType() == tSemicolon) // When there are more variables.
  {
    Consume(tSemicolon);
    return GetParams(_scanner, _tm, paramVec, (paramVec->at(paramVec->size() - 1)).size() + lastIdx - 1); // Recursive call.
  }
  else
  {
    return oneTypeResult; // Return the type for recursive call.
  }
}

CType* CParser::GetVariables (CScanner* _scanner, vector<CToken*>* varVec)
{
  CToken* varId = new CToken();
  Consume(tId, varId); // Gets identifier for variable.
  
  //varVec->resize(varVec->size() + 1);
  varVec->push_back(varId);
  //cout << "===(DEBUG)===Added variable : " << varId->GetValue() << ", size of varVec is : " << varVec->size() << endl;
  
  while (_scanner->Peek().GetType() == tComma) // When there are more variable of same type.
  {
    Consume(tComma);
    varId = new CToken();
    Consume(tId, varId); // Gets identifier for variable.
    
    //varVec->resize(varVec->size() + 1);
    varVec->push_back(varId); // Push got identifier into variable vector.
    //cout << "===(DEBUG)===Added variable : " << varId->GetValue() << ", size of varVec is : " << varVec->size() << endl;
  }
  Consume(tColon);
  CType* identType = NULL;
  identType = type(CTypeManager::Get(), false); // Gets variables' type.
  return identType; // Return the type to use for adding variable to procedure/function symbol table.
}

/*
CType* CParser::GetVariables (CScanner* _scanner, CAstScope* s, CTypeManager* _tm)
{
  //printf("In GetVariables function!\n");
  //cout << "===(DEBUG)===Current scanner peek : " << _scanner->Peek().GetValue() << endl;
  CToken* varId = new CToken();
  Consume(tId, varId); // Gets identifier for variable.
  
  CType* identType = NULL;
  
  if (_scanner->Peek().GetType() == tComma) // When there are more variable of same type.
  {
    Consume(tComma);
    identType = GetVariables(_scanner, s, _tm); // Recursive call.
    if (s->GetSymbolTable()->FindSymbol(varId->GetValue(), sLocal) != NULL)
    {
      SetError(varId, "duplicate variable declaration '" + varId->GetValue() + "'.");
    }
    else
    {
      bool addVarRes = s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType)); // When above recursive call gives type, add variable to scope's symbol table.
      if (!addVarRes)
      {
        SetError(varId, "duplicate variable declaration '" + varId->GetValue() + "'.");
      }
      //cout << "===(DEBUG)=== Added variable <" << varId->GetValue() << "> to scope." << endl;
    } 
  }
  else // When there are no more variable of same type.
  {
    Consume(tColon);
    identType = type(_tm, false); // Get type.
    //printf("Got type!\n");
    if (!identType->IsBoolean() && !identType->IsChar() && !identType->IsInt() && !identType->IsArray() && !identType->IsPointer()) // Check for type.
    {
      printf("Type error!\n");
    }
    bool addVarRes = s->GetSymbolTable()->AddSymbol(s->CreateVar(varId->GetValue(), identType)); // Add variable to scope's symbol table.
    if (!addVarRes)
    //cout << "===(DEBUG)=== Added variable <" << varId->GetValue() << "> to scope." << endl; 
  }
  return identType; // Return the type for recursive call.
}
*/

const CType* CParser::GenerateArrayType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  CToken* elemCount = new CToken();
  if (_scanner->Peek().GetType() != tRBracket)
  {
    Consume(tNum, elemCount); // Gets number of element in this dimension.
  }
  Consume(tRBracket);
  char* endPtr = 0; // For string to integer conversion.
  int nelem = -1; // Number of elements in this dimension.
  if (elemCount->GetType() != tUndefined) // When number of elements are specified, get it.
  {
    nelem = strtol(elemCount->GetValue().c_str(), &endPtr, 10);
  }
  //cout << "===(DEBUG)===In GenerateArrayType function, got nelem of " << nelem << endl;
  if (_scanner->Peek().GetType() == tLBracket) // When more dimensions exist.
  {
    Consume(tLBracket);
    return _tm->GetArray(nelem, GenerateArrayType(_scanner, _tm, _baseType)); // Type for this dimension will be array of array by recursive call.
  }
  else // When there are no more dimensions exist. i.e., 1st dimension.
  {
    return _tm->GetArray(nelem, _baseType); // Type of this dimension will be array of _baseType.
  }
}

const CType* CParser::GeneratePointerType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType)
{
  // This function is not used any more.
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
  if (_scanner->Peek().GetType() == tBoolean) // Boolean basetype, (multi-dimensional) array or pointer type.
  {
    Consume(tBoolean);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of boolean (multi-dimensional) array or pointer to (multi-dimensional) boolean array type.
    {
      Consume(tLBracket);
      if (_isParam) // Pointer to boolean (multi-dimensional) array type.
      {
        return (CType*)_tm->GetPointer(GenerateArrayType(_scanner, _tm, (CType*)_tm->GetBool()));
      }
      else // Boolean (multi-dimensional) array type.
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetBool());
      }
    }
    else // Boolean basetype.
    {
      return (CType*)_tm->GetBool();
    }
  }
  else if (_scanner->Peek().GetType() == tChar) // Character basetype, (multi-dimensional) array or pointer type.
  {
    Consume(tChar);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of character (multi-dimensional) array or pointer to character (multi-dimensional) array type.
    {
      Consume(tLBracket);
      if (_isParam) // Pointer to character (multi-dimensional) array type.
      {
        return (CType*)_tm->GetPointer(GenerateArrayType(_scanner, _tm, (CType*)_tm->GetChar()));
      }
      else // Character (multi-dimensional) array type.
      {
        return (CType*)GenerateArrayType(_scanner, _tm, (CType*)_tm->GetChar());
      }
    }
    else // Character basetype.
    {
      return (CType*)_tm->GetChar();
    }
  }
  else if (_scanner->Peek().GetType() == tInteger) // Integer basetype, (multi-dimensional) array or pointer type.
  {
    Consume(tInteger);
    if (_scanner->Peek().GetType() == tLBracket) // Possibility of integer (multi-dimensional) array or pointer to integer (multi-dimensional) array type.
    {
      Consume(tLBracket);
      if (_isParam) // Pointer to integer (multi-dimensional) array type.
      {
        return (CType*)_tm->GetPointer(GenerateArrayType(_scanner, _tm, (CType*)_tm->GetInt()));
      }
      else // Integer (multi-dimensional) array type.
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
        CToken* commonFirst = new CToken();
        Consume(tId, commonFirst); // Consume common FIRST.
        //cout << "===(DEBUG)===Case of assignment or subroutineCall in statement. commentFirst : " << commonFirst->GetValue() << endl;
        
        if (_scanner->Peek().GetType() == tAssign || _scanner->Peek().GetType() == tLBracket) // Case of assignment. When tLBracket is peeked, it is qualident.
        {
          //cout << "===(DEBUG)===Case of assignment in statement." << endl;
          st = assignment(s, commonFirst);
        }
        else if (_scanner->Peek().GetType() == tLBracketRound) // Case of subroutineCall.
        {
          //cout << "===(DEBUG)===Case of subroutineCall in statement." << endl;
          st = subroutineCall(s, commonFirst, typeManager);
          //cout << "===(DEBUG)===Got subroutine call. Next token is : " << _scanner->Peek().GetValue() << endl;
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
        SetError(_scanner->Peek(), "statement expected.");
      }
      //cout << "===(DEBUG)===Now setting tail and head of statement sequence. Next token is : " << _scanner->Peek().GetValue() << endl;
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
      //cout << "===(DEBUG)===Set tail and head of statement sequence. Next token is : " << _scanner->Peek().GetValue() << endl;
      
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
  if (s->GetSymbolTable()->FindSymbol(prevToken->GetValue()) == NULL) // When there are no symbol with given name, throw error.
  {
    SetError(prevToken, "undefined identifier.");
  }
  const CSymProc* funcSymbol = dynamic_cast<const CSymProc*>(s->GetSymbolTable()->FindSymbol(prevToken->GetValue())); // Find symbol for procedure/function.
  //CType* funcDataType = funcSymbol->GetDataType()
  if (funcSymbol == NULL) // When there is symbol with given name but it is not procedure/function, throw error.
  {
    SetError(prevToken, "invalid procedure/function identifier.");
  }
  int nParams = funcSymbol->GetNParams(); // Get number of parameters for checking argument number.
  CAstFunctionCall* funcCall = new CAstFunctionCall(prevToken, funcSymbol); // Make functionCall AST node.
  //cout << "===(DEBUG)===Constructed CAstFunctionCall in subroutineCall function." << endl;
  AddArguments(s, _scanner, _tm, funcCall, nParams); // Add arguments to procedure/function.
  
  return new CAstStatCall(prevToken, funcCall);
}

void CParser::AddArguments(CAstScope* s, CScanner* _scanner, CTypeManager* _tm, CAstFunctionCall* _fc, int nParams)
{
  Consume(tLBracketRound);
  
  int gotArgs = 0; // Number of arguments got.
    
  if (_scanner->Peek().GetType() == tRBracketRound) // No argument to add.
  {
    CToken* t = new CToken();
    Consume(tRBracketRound, t);
    if (nParams > gotArgs) // When there are no arguments, but argument(s) are needed, throw error.
    {
      SetError(t, "number of arguments expected : " + to_string(nParams) + ", got : " + to_string(gotArgs) + ".");
    }
    return;
  }
  else // Argument(s) exist(s).
  {
    CAstExpression* exp = expression(s); // Get argument.
    //cout << "===(DEBUG)===Got expression for function argument." << endl;
    if (exp == NULL)
    {
      //cout << "===(DEBUG)===Expression for function argument is NULL." << endl;
    }
    CToken t = _scanner->Peek();
    if (exp->GetType()->IsArray()) // When expression has return type of array.
    {
      //cout << "===(DEBUG)===Return type of expression is array." << endl;
      exp = new CAstSpecialOp(t, opAddress, exp); // Reference the array.
    }
    //cout << "===(DEBUG)===Got argument as form of expression. Next token is : " << _scanner->Peek().GetValue() << endl;
    _fc->AddArg(exp); // Add argument to functionCall.
    gotArgs++; // Count how many arguments are consumed.
    while(_scanner->Peek().GetType() == tComma) // Until there are no more argument left, iterate.
    {
      Consume(tComma);
      exp = expression(s); // Get argument.
      //cout << "===(DEBUG)===Got expression for function argument." << endl;
      if (exp == NULL)
      {
        //cout << "===(DEBUG)===Expression for function argument is NULL." << endl;
      }
      t = _scanner->Peek();
      if (exp->GetType()->IsArray()) // When expression has return type of array.
      {
        //cout << "===(DEBUG)===Return type of expression is array." << endl;
        exp = new CAstSpecialOp(t, opAddress, exp); // Reference the array.
      }
      //cout << "===(DEBUG)===Got argument as form of expression. Next token is : " << _scanner->Peek().GetValue() << endl;
      _fc->AddArg(exp); // Add argument to functionCall.
      gotArgs++; // Count how many arguments are consumed.
    }
  }
  CToken* chk = new CToken();
  Consume(tRBracketRound, chk);
  if (nParams != gotArgs) // when number of parameters does not match the number of arguments the parser got, throw error.
  {
    SetError(chk, "number of arguments expected : " + to_string(nParams) + ", got : " + to_string(gotArgs) + ".");
  }
}

CAstStatIf* CParser::ifStatement(CAstScope* s)
{
  //
  // ifStatement         = "if" "(" expression ")" "then" statSequence [ "else" statSequence ] "end".
  //
  CToken t;
  
  Consume(tIf, &t);
  Consume(tLBracketRound);
  
  CAstExpression* exp = expression(s); // Get expression for if condition.
  
  Consume(tRBracketRound);
  Consume(tThen);
  
  CAstStatement* statSeq = statSequence(s); // Get statement sequence for if body.
  
  if (_scanner->Peek().GetType() == tEnd) // When there are no else body.
  {
    Consume(tEnd);
    return new CAstStatIf(t, exp, statSeq, NULL); // Return new CAstStatIf.
  }
  else // When there is else body.
  {
    Consume(tElse);
    CAstStatement* elseStatSeq = statSequence(s); // Get statement sequence for else body.
    Consume(tEnd);
    return new CAstStatIf(t, exp, statSeq, elseStatSeq); // Return new CAstStatIf.
  }
}

CAstStatWhile* CParser::whileStatement(CAstScope* s)
{
  //
  // whileStatement      = "while" "(" expression ")" "do" statSequence "end".
  //
  
  CToken t;
  
  Consume(tWhile, &t);
  Consume(tLBracketRound);
  
  CAstExpression* exp = expression(s); // Get expression for while condition.
  
  Consume(tRBracketRound);
  Consume(tDo);
  
  CAstStatement* statSeq = statSequence(s); // Get statement sequence for while body.
  Consume(tEnd);
  
  return new CAstStatWhile(t, exp, statSeq); // Return new CAstStatWhile.
}

CAstStatReturn* CParser::returnStatement(CAstScope* s)
{
  //
  // returnStatement     = "return" [ expression ].
  //
  
  CToken t;
  
  Consume(tReturn, &t);
  EToken checkExp = _scanner->Peek().GetType(); // Token type for checking return has its expression or not.
  if (checkExp == tEnd || checkExp == tElse || checkExp == tSemicolon) // When return has no expression.
  {
    return new CAstStatReturn(t, s, NULL); // Return new CAstStatReturn.
  }
  else // When return has its expression.
  {
    CAstExpression* exp = expression(s); // Get expression for return.
    return new CAstStatReturn(t, s, exp); // Return new CAstStatReturn.
  }
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
  //cout << "===(DEBUG)===Start of assignment" << endl;
  CToken t;
  const CSymbol* symbol = s->GetSymbolTable()->FindSymbol(lhs->GetValue()); // Find symbol for LHS, which is qualident or ident.
  //cout << "===(DEBUG)===Found symbol : " << symbol->GetName() << endl;
  
  if (symbol == NULL) // If there are no symbol for LHS, throw error.
  {
    SetError(lhs, "undefined identifier.");
  }

  if (_scanner->Peek().GetType() == tLBracket) // When LHS is qualident.
  {
    CAstArrayDesignator* qualid = new CAstArrayDesignator(lhs, symbol); // Make qualident object.
    while(_scanner->Peek().GetType() == tLBracket) // Gets all indices.
    {
      Consume(tLBracket);
      CAstExpression* idxExp = expression(s); // Get index.
      //cout << "===(DEBUG)===Got exp for index of qualident." << endl;
      qualid->AddIndex(idxExp); // Set index of qualident.
      Consume(tRBracket);
    }
    qualid->IndicesComplete(); // Declare that indexing is finished.
    
    Consume(tAssign, &t);
    
    CAstExpression* rhs = expression(s); // Gets RHS.
    
    //cout << "===(DEBUG)===Got LHS and RHS of assignment." << endl;
    
    return new CAstStatAssign(t, qualid, rhs);
  }
  else // When LHS is ident.
  {
    CAstDesignator* id = new CAstDesignator(lhs, symbol); // Make ident object.
    
    //cout << "===(DEBUG)===Made new CAstDesignator class for id." << endl;
    
    Consume(tAssign, &t);
    
    //cout << "===(DEBUG)===Consumed assignment token." << endl;
    
    CAstExpression *rhs = expression(s); // Gets RHS.
    
    //cout << "===(DEBUG)===Got LHS and RHS of assignment." << endl;
    
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
  
  //cout << "===(DEBUG)===Now at expression function." << endl;

  left = simpleexpr(s); // Gets first simpleexpr.
  
  //cout << "===(DEBUG)===Got simpleexpr for left side of expression. Next token is : " << _scanner->Peek().GetValue() << endl;

  if (_scanner->Peek().GetType() == tRelOp) // When form of simpleexpr relOp simpleexpr.
  {
    //cout << "===(DEBUG)===When relOp exists." << endl;
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
  
  if (_scanner->Peek().GetValue() == "+") // Unary positive operator.
  {
    CToken* unaryOp = new CToken();
    Consume(tTerm, unaryOp); // Get unary operator token.
    n = new CAstUnaryOp(unaryOp, opPos, term(s)); // Construct term with unary operator included.
  }
  else if (_scanner->Peek().GetValue() == "-") // Unary negative operator.
  {
    CToken* unaryOp = new CToken();
    CToken* numtok = new CToken();
    Consume(tTerm, unaryOp); // Get unary operator token.
    if (_scanner->Peek().GetType() == tNum) // When number comes right aftre unary negative operator, negate number.
    {
      char** endPtr = 0;
      Consume(tNum, numtok);
      n = new CAstConstant(numtok, CTypeManager::Get()->GetInt(), -(strtoll(numtok->GetValue().c_str(), endPtr, 10))); // Negated number.
    }
    else
    {
      n = new CAstUnaryOp(unaryOp, opNeg, term(s)); // Construct term with unary operator included.
    }
  }
  else // When no unary operator prefixed.
  {
    n = term(s); // Construct term.
    //cout << "===(DEBUG)===Constructed term for simpleexpr. Next token is : " << _scanner->Peek().GetValue() << endl;
  }

  while (_scanner->Peek().GetType() == tTerm) // Until there are no term left, iterate and construct simpleexpr. Previous term will be left side of Binary operator, new term will be right side.
  {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tTerm, &t); // Get termOp token.

    r = term(s); // Get RHS term.
    if (t.GetValue() == "+") // Case of binary addition operator.
    {
      n = new CAstBinaryOp(t, opAdd, l, r);
    }
    else if (t.GetValue() == "-") // Case of binary subtraction operator.
    {
      n = new CAstBinaryOp(t, opSub, l, r);
    }
    else // Case of boolean OR operator.
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

  n = factor(s); // Since no prefix exists before factor and at least one factor always exist, construct factor.
  
  //cout << "===(DEBUG)===Constructed factor term. Next token is : " << _scanner->Peek().GetValue() << endl;

  EToken tt = _scanner->Peek().GetType(); // Get token enumerator for next token. Used for classfication.

  while (tt == tFact) // Until there are no factor left, iterate and construct term. 
  {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tFact, &t); // Get factOp operator.

    r = factor(s); // Construct term.

    if (t.GetValue() == "*") // Case of binary multiplication operator.
    {
      n = new CAstBinaryOp(t, opMul, l, r);
    }
    else if (t.GetValue() == "/") // Case of binary division operator.
    {
      n = new CAstBinaryOp(t, opDiv, l, r);
    }
    else // Case of boolean AND operator.
    {
      n = new CAstBinaryOp(t, opAnd, l, r);
    }

    tt = _scanner->Peek().GetType(); // Ready for next iteration.
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
  // FOLLOW(qualident) = "*" | "/" | "&&" | "]" | ")" | "," | "end" | "else" | ";" | "=" | "#" | "<" | "<=" | ">" | ">=" | "+" | "-" | "||" | ":=" |
  //

  CToken t;
  CTypeManager* typeManager = CTypeManager::Get(); // Type manager.
  EToken tt = _scanner->Peek().GetType(); // Token enumerator for next token. Used for classification.
  CAstExpression *unary = NULL, *n = NULL;
  
  //cout << "===(DEBUG)===Now processing factor. Next token : " << _scanner->Peek().GetValue() << "(type : " << _scanner->Peek().GetName() << ")" << endl;
  
  if (tt == tId) // Possibility of qualident or subroutineCall
  {
    //cout << "===(DEBUG)===factor qualident/subroutineCall case. Next token : " << _scanner->Peek().GetValue() << endl;
    CToken* factorId = new CToken();
    Consume(tId, factorId); // Get common FIRST.
    tt = _scanner->Peek().GetType(); // Peek the next.
    if (tt == tLBracketRound) // Case of subroutineCall.
    {
      //cout << "===(DEBUG)===factor subroutineCall case." << endl;
      const CSymProc* funcSymbol = dynamic_cast<const CSymProc*>(s->GetSymbolTable()->FindSymbol(factorId->GetValue())); // Gets procedure/function symbol.
      if (s->GetSymbolTable()->FindSymbol(factorId->GetValue()) == NULL) // When there are no such symbol in symbol table, throw error.
      {
        SetError(factorId, "undefined identifier.");
      }
      if (funcSymbol == NULL) // When there is symbol but not type of procedure/function symbol, throw error.
      {
        SetError(factorId, "invalid procedure/function identifier.");
      }
      CAstFunctionCall* funcCall = new CAstFunctionCall(factorId, funcSymbol); // Construct function call.
      AddArguments(s, _scanner, typeManager, funcCall, funcSymbol->GetNParams()); // Add arguments to procedure/function call.
      //n = subroutineCall(s, factorId, typeManager);
      n = funcCall;
    }
    else if (tt == tLBracket) // Case of qualident (not ident).
    {
      //cout << "===(DEBUG)===factor qualident case. factorId : " << factorId->GetValue() << endl;
      if (s->GetSymbolTable()->FindSymbol(factorId->GetValue()) == NULL) // When there is no such symbol.
      {
        SetError(factorId, "undefined identifier.");
      }
      const CSymbol* qualIdSymbol = dynamic_cast<const CSymbol*>(s->GetSymbolTable()->FindSymbol(factorId->GetValue())); // Find symbol for qualident.
      if (qualIdSymbol->GetSymbolType() == stProcedure) // When there is symbol but is type of procedure/function, throw error.
      {
        SetError(factorId, "designator expected.");
      }
      CAstArrayDesignator* qualid = new CAstArrayDesignator(factorId, qualIdSymbol); // Construct qualident variable.
      while(tt == tLBracket) // Set indices of qualident variable.
      {
        Consume(tLBracket);
        CAstExpression* idxExp = expression(s); // Get expression for index.
        qualid->AddIndex(idxExp); // Set index.
        Consume(tRBracket);
        tt = _scanner->Peek().GetType(); // To check iteration should continu or not.
      }
      qualid->IndicesComplete(); // Indicate that index addition is finished.
      n = qualid;
    }
    else if (tt == tFact || tt == tRBracket || tt == tRBracketRound || tt == tComma || tt == tEnd || tt == tElse || tt == tSemicolon || tt == tRelOp || tt == tTerm || tt == tAssign) // Case of ident.
    {
      //cout << "===(DEBUG)===factor ident case. Next token is : " << _scanner->Peek().GetValue() << endl;
      if (s->GetSymbolTable()->FindSymbol(factorId->GetValue()) == NULL) // When there is no such symbol.
      {
        SetError(factorId, "undefined identifier");
      }
      const CSymbol* idSymbol = s->GetSymbolTable()->FindSymbol(factorId->GetValue()); // Find symbol for ident.
      //cout << "===(DEBUG)===Current symbol table size is : " << s->GetSymbolTable()->GetSymbols().size() << endl;
      if (idSymbol->GetSymbolType() == stProcedure) // When there is symbol but is type of procedure/function, throw error.
      {
        SetError(factorId, "designator expected.");
      }
      n = new CAstDesignator(factorId, idSymbol); // Construct ident variable.
    }
  }
  else if (tt == tNum) // Case of number.
  {
    //cout << "===(DEBUG)===factor number case." << endl;
    CToken* num = new CToken();
    Consume(tNum, num); // Get number token.
    char* endPtr = 0;
    long long numValue = strtoll(num->GetValue().c_str(), &endPtr, 10); // Parse number value.
    n = new CAstConstant(num, typeManager->GetInt(), numValue); // Construct number constant.
  }
  else if (tt == tTrue) // Case of boolean TRUE.
  {
    //cout << "===(DEBUG)===factor TRUE case." << endl;
    CToken* booleanTrue = new CToken();
    Consume(tTrue, booleanTrue); // Get boolean TRUE token.
    long long numValue = 1; // 1 for TRUE, 0 for FALSE.
    n = new CAstConstant(booleanTrue, typeManager->GetBool(), numValue); // Construct boolean constant.
  }
  else if (tt == tFalse) // Case of boolean FALSE.
  {
    //cout << "===(DEBUG)===factor FALSE case." << endl;
    CToken* booleanFalse = new CToken();
    Consume(tFalse, booleanFalse); // Get boolean FALSE token.
    long long numValue = 0; // 1 for TRUE, 0 for FALSE.
    n = new CAstConstant(booleanFalse, typeManager->GetBool(), numValue); // Construct boolean constant.
  }
  else if (tt == tCharacter) // Case of character.
  {
    //cout << "===(DEBUG)===factor character case." << endl;
    // TODO: Check for escape characters.
    CToken* ch = new CToken();
    Consume(tCharacter, ch); // Get character token.
    long long charValue = ch->GetValue().c_str()[0]; // Parse character value to integer value.
    n = new CAstConstant(ch, typeManager->GetChar(), charValue); // Construct character constant.
  }
  else if (tt == tConstChar)
  {
    //cout << "===(DEBUG)===factor const character case." << endl;
    CToken* constCh = new CToken();
    Consume(tConstChar, constCh); // Get const char token.
    //cout << "===(DEBUG)===Escaped value is : " << constCh->escape(constCh->GetValue()) << endl;
    //cout << "===(DEBUG)===Unescaped value is : " << constCh->unescape(constCh->GetValue()) << endl;
    long long constCharValue = constCh->unescape(constCh->GetValue()).c_str()[0]; // Parse character value to integer value.
    n = new CAstConstant(constCh, typeManager->GetChar(), constCharValue); // Construct character constant.
  }
  else if (tt == tString) // Case of string.
  {
    //cout << "===(DEBUG)===Case of string in factor. Next token is : " << _scanner->Peek().GetValue() << endl;
    CToken* str = new CToken();
    Consume(tString, str); // Get string token.
    //cout << "===(DEBUG)===Got token for string. token value is : " << str->GetValue() << ", next token is : " << _scanner->Peek().GetValue() << endl;
    n = new CAstStringConstant(*str, str->GetValue(), s); // Construct string constant.
    //cout << "===(DEBUG)===Length of string is : " << strlen(CToken::unescape(str->GetValue()).c_str())+1 << endl;
    //cout << "===(DEBUG)===Constructed CAstStringConstant for string. Next token is : " << _scanner->Peek().GetValue() << endl;
  }
  else if (tt == tLBracketRound) // Case of expression.
  {
    //cout << "===(DEBUG)===factor LBracketRound(expression) case." << endl;
    Consume(tLBracketRound);
    n = expression(s); // Get expression.
    Consume(tRBracketRound);
  }
  else if (tt == tExclam) // Case of binary negation.
  {
    //cout << "===(DEBUG)===factor exclam(binary negation) case." << endl;
    CToken* exclam = new CToken();
    Consume(tExclam, exclam); // Get exclamanation token, which represents binary negation.
    n = new CAstUnaryOp(exclam, opNot, factor(s)); // Construct negation of factor.(recursive call)
  }
  else // Invalid factor.
  {
    //cout << "===(DEBUG)===factor invalid case." << endl;
    cout << "got " << _scanner->Peek() << endl;
    SetError(_scanner->Peek(), "factor expected.");
  }

  /*
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
  */

  return n;
}

CAstConstant* CParser::number(void)
{
  //
  // number ::= digit { digit }.
  //
  // "digit { digit }" is scanned as one token (tNum)
  //
  // This function is not used anymore.
  //

  CToken t;

  Consume(tNum, &t);

  errno = 0;
  long long v = strtoll(t.GetValue().c_str(), NULL, 10);
  if (errno != 0) SetError(t, "invalid number.");

  return new CAstConstant(t, CTypeManager::Get()->GetInt(), v);
}