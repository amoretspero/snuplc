//------------------------------------------------------------------------------
/// @brief SnuPL abstract syntax tree
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/05/22 Bernhard Egger reimplemented TAC generation
/// 2013/11/04 Bernhard Egger added typechecks for unary '+' operators
/// 2016/03/12 Bernhard Egger adapted to SnuPL/1
/// 2014/04/08 Bernhard Egger assignment 2: AST for SnuPL/-1
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

#include <iostream>
#include <cassert>
#include <cstring>

#include <typeinfo>

#include "ast.h"
using namespace std;


//------------------------------------------------------------------------------
// CAstNode
//
int CAstNode::_global_id = 0;

CAstNode::CAstNode(CToken token)
  : _token(token), _addr(NULL)
{
  _id = _global_id++;
}

CAstNode::~CAstNode(void)
{
  if (_addr != NULL) delete _addr;
}

int CAstNode::GetID(void) const
{
  return _id;
}

CToken CAstNode::GetToken(void) const
{
  return _token;
}

const CType* CAstNode::GetType(void) const
{
  return CTypeManager::Get()->GetNull();
}

string CAstNode::dotID(void) const
{
  ostringstream out;
  out << "node" << dec << _id;
  return out.str();
}

string CAstNode::dotAttr(void) const
{
  return " [label=\"" + dotID() + "\"]";
}

void CAstNode::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << dotID() << dotAttr() << ";" << endl;
}

CTacAddr* CAstNode::GetTacAddr(void) const
{
  return _addr;
}

ostream& operator<<(ostream &out, const CAstNode &t)
{
  return t.print(out);
}

ostream& operator<<(ostream &out, const CAstNode *t)
{
  return t->print(out);
}

//------------------------------------------------------------------------------
// CAstScope
//
CAstScope::CAstScope(CToken t, const string name, CAstScope *parent)
  : CAstNode(t), _name(name), _symtab(NULL), _parent(parent), _statseq(NULL),
    _cb(NULL)
{
  if (_parent != NULL) _parent->AddChild(this);
}

CAstScope::~CAstScope(void)
{
  delete _symtab;
  delete _statseq;
  delete _cb;
}

const string CAstScope::GetName(void) const
{
  return _name;
}

CAstScope* CAstScope::GetParent(void) const
{
  return _parent;
}

size_t CAstScope::GetNumChildren(void) const
{
  return _children.size();
}

CAstScope* CAstScope::GetChild(size_t i) const
{
  assert(i < _children.size());
  return _children[i];
}

CSymtab* CAstScope::GetSymbolTable(void) const
{
  assert(_symtab != NULL);
  return _symtab;
}

void CAstScope::SetStatementSequence(CAstStatement *statseq)
{
  _statseq = statseq;
}

CAstStatement* CAstScope::GetStatementSequence(void) const
{
  return _statseq;
}

bool CAstScope::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstScope" << endl;
  bool result = true;
  
  try
  {
    CAstStatement* s = _statseq; // Gets statement sequences of this scope.
    while (result && (s != NULL)) // Iterates through statement sequences and typecheck.
    {
      result = s->TypeCheck(t, msg);
      s = s->GetNext();
    }
    
    vector<CAstScope*>::const_iterator it = _children.begin(); // Gets child scopes.
    while (result && (it != _children.end())) // Iterates through child scopes and typecheck.
    {
      result = (*it)->TypeCheck(t, msg);
      it++;
    }
  }
  catch (...)
  {
    result = false;
  }

  return result;
}

ostream& CAstScope::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "CAstScope: '" << _name << "'" << endl;
  out << ind << "  symbol table:" << endl;
  _symtab->print(out, indent+4);
  out << ind << "  statement list:" << endl;
  CAstStatement *s = GetStatementSequence();
  if (s != NULL) {
    do {
      s->print(out, indent+4);
      s = s->GetNext();
    } while (s != NULL);
  } else {
    out << ind << "    empty." << endl;
  }

  out << ind << "  nested scopes:" << endl;
  if (_children.size() > 0) {
    for (size_t i=0; i<_children.size(); i++) {
      _children[i]->print(out, indent+4);
    }
  } else {
    out << ind << "    empty." << endl;
  }
  out << ind << endl;

  return out;
}

void CAstScope::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  CAstStatement *s = GetStatementSequence();
  if (s != NULL) {
    string prev = dotID();
    do {
      s->toDot(out, indent);
      out << ind << prev << " -> " << s->dotID() << " [style=dotted];" << endl;
      prev = s->dotID();
      s = s->GetNext();
    } while (s != NULL);
  }

  vector<CAstScope*>::const_iterator it = _children.begin();
  while (it != _children.end()) {
    CAstScope *s = *it++;
    s->toDot(out, indent);
    out << ind << dotID() << " -> " << s->dotID() << ";" << endl;
  }

}

CTacAddr* CAstScope::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CCodeBlock* CAstScope::GetCodeBlock(void) const
{
  return _cb;
}

void CAstScope::SetSymbolTable(CSymtab *st)
{
  if (_symtab != NULL) delete _symtab;
  _symtab = st;
}

void CAstScope::AddChild(CAstScope *child)
{
  _children.push_back(child);
}


//------------------------------------------------------------------------------
// CAstModule
//
CAstModule::CAstModule(CToken t, const string name)
  : CAstScope(t, name, NULL)
{
  SetSymbolTable(new CSymtab());
}

CSymbol* CAstModule::CreateVar(const string ident, const CType *type)
{
  return new CSymGlobal(ident, type);
}

string CAstModule::dotAttr(void) const
{
  return " [label=\"m " + GetName() + "\",shape=box]";
}



//------------------------------------------------------------------------------
// CAstProcedure
//
CAstProcedure::CAstProcedure(CToken t, const string name,
                             CAstScope *parent, CSymProc *symbol)
  : CAstScope(t, name, parent), _symbol(symbol)
{
  assert(GetParent() != NULL);
  SetSymbolTable(new CSymtab(GetParent()->GetSymbolTable()));
  assert(_symbol != NULL);
}

CSymProc* CAstProcedure::GetSymbol(void) const
{
  return _symbol;
}

CSymbol* CAstProcedure::CreateVar(const string ident, const CType *type)
{
  return new CSymLocal(ident, type);
}

const CType* CAstProcedure::GetType(void) const
{
  return GetSymbol()->GetDataType();
}

string CAstProcedure::dotAttr(void) const
{
  return " [label=\"p/f " + GetName() + "\",shape=box]";
}


//------------------------------------------------------------------------------
// CAstType
//
CAstType::CAstType(CToken t, const CType *type)
  : CAstNode(t), _type(type)
{
  assert(type != NULL);
}

const CType* CAstType::GetType(void) const
{
  return _type;
}

ostream& CAstType::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "CAstType (" << _type << ")" << endl;
  return out;
}


//------------------------------------------------------------------------------
// CAstStatement
//
CAstStatement::CAstStatement(CToken token)
  : CAstNode(token), _next(NULL)
{
}

CAstStatement::~CAstStatement(void)
{
  delete _next;
}

void CAstStatement::SetNext(CAstStatement *next)
{
  _next = next;
}

CAstStatement* CAstStatement::GetNext(void) const
{
  return _next;
}

CTacAddr* CAstStatement::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStatAssign
//
CAstStatAssign::CAstStatAssign(CToken t,
                               CAstDesignator *lhs, CAstExpression *rhs)
  : CAstStatement(t), _lhs(lhs), _rhs(rhs)
{
  assert(lhs != NULL);
  assert(rhs != NULL);
}

CAstDesignator* CAstStatAssign::GetLHS(void) const
{
  return _lhs;
}

CAstExpression* CAstStatAssign::GetRHS(void) const
{
  return _rhs;
}

bool CAstStatAssign::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatAssign" << endl;
  bool lhsTypeCheckRes = _lhs->TypeCheck(t, msg); // Type checks lhs.
  bool rhsTypeCheckRes = _rhs->TypeCheck(t, msg); // Type checks rhs.
  
  if (!lhsTypeCheckRes || !rhsTypeCheckRes) // If either one fails, return false.
  {
    return false;
  }
  
  const CType* lhsType = _lhs->GetType(); // Gets the type of lhs.
  const CType* rhsType = _rhs->GetType(); // Gets the type of rhs.
  
  if (!lhsType->Match(rhsType)) // When type of rhs does not matches type of lhs.
  {
    *t = _rhs->GetToken(); // For error reporting.
        
    std::stringstream ssLHS; // Set stringstream for LHS.
    ssLHS << _lhs->GetType(); // Add type of LHS to stringstream.
    std::stringstream ssRHS; // Set stringstream for RHS.
    ssRHS << _rhs->GetType(); // Add type of RHS to stringstream.
    
    *msg = "Type of rhs and lhs does not match.";
    *msg += "\n  LHS: ";
    *msg += ssLHS.str() + "\n  RHS: " + ssRHS.str();
    return false;
  }
  
  if (!GetLHS()->GetType()->IsScalar() && !GetLHS()->GetType()->IsPointer()) // When type of LHS is not assignment. SnuPL/1 does not support assignment to compound types.
  {
    *t = _lhs->GetToken();
    
    std::stringstream ssLHS; // Set stringstream for LHS.
    ssLHS << _lhs->GetType(); // Add type of LHS to stringstream.
    std::stringstream ssRHS; // Set stringstream for RHS.
    ssRHS << _rhs->GetType(); // Add type of RHS to stringstream.
    
    *msg = "assignments to compound types are not supported.\n";
    *msg += "  ";
    *msg += "LHS: " + ssLHS.str() + "\n  " + "RHS: " + ssRHS.str();
    return false;
  }
  
  return true;
}

const CType* CAstStatAssign::GetType(void) const
{
  return _lhs->GetType();
}

ostream& CAstStatAssign::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << ":=" << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  _lhs->print(out, indent+2);
  _rhs->print(out, indent+2);

  return out;
}

string CAstStatAssign::dotAttr(void) const
{
  return " [label=\":=\",shape=box]";
}

void CAstStatAssign::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _lhs->toDot(out, indent);
  out << ind << dotID() << "->" << _lhs->dotID() << ";" << endl;
  _rhs->toDot(out, indent);
  out << ind << dotID() << "->" << _rhs->dotID() << ";" << endl;
}

CTacAddr* CAstStatAssign::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStatCall
//
CAstStatCall::CAstStatCall(CToken t, CAstFunctionCall *call)
  : CAstStatement(t), _call(call)
{
  assert(call != NULL);
}

CAstFunctionCall* CAstStatCall::GetCall(void) const
{
  return _call;
}

bool CAstStatCall::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatCall" << endl;
  return GetCall()->TypeCheck(t, msg); // Typechecks the call.
}

const CType* CAstStatCall::GetType(void) const
{
  return GetCall()->GetType();
}

ostream& CAstStatCall::print(ostream &out, int indent) const
{
  _call->print(out, indent);

  return out;
}

string CAstStatCall::dotID(void) const
{
  return _call->dotID();
}

string CAstStatCall::dotAttr(void) const
{
  return _call->dotAttr();
}

void CAstStatCall::toDot(ostream &out, int indent) const
{
  _call->toDot(out, indent);
}

CTacAddr* CAstStatCall::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStatReturn
//
CAstStatReturn::CAstStatReturn(CToken t, CAstScope *scope, CAstExpression *expr)
  : CAstStatement(t), _scope(scope), _expr(expr)
{
  assert(scope != NULL);
}

CAstScope* CAstStatReturn::GetScope(void) const
{
  return _scope;
}

CAstExpression* CAstStatReturn::GetExpression(void) const
{
  return _expr;
}

bool CAstStatReturn::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatReturn" << endl;
  const CType* st = GetScope()->GetType();
  //cout << "===(DEBUG)===Scope name is : <" << GetScope()->GetName() << ">." << endl;
  CAstExpression* e = GetExpression();
  
  if (st->Match(CTypeManager::Get()->GetNull())) // When return type is NULL. Should not return anything.
  {
    if (e != NULL)
    {
      if (t != NULL) // If token is not given, set token.
      {
        *t = e->GetToken();
      }
      if (msg != NULL) // Set error message.
      {
        *msg = "superfluous expression after return.";
      }
      return false;
    }
  }
  else // When return type is not NULL. Must return appropriate typed value.
  {
    if (e == NULL)
    {
      if (t != NULL) // If token is not given, set token.
      {
        *t = GetToken();
      }
      if (msg != NULL) // Set error message.
      {
        *msg = "expression expected after return.";
      }
      return false;
    }
    
    if (!e ->TypeCheck(t, msg)) // If typecheck fails for return expression.
    {
      return false;
    }
    
    if (!st->Match(e->GetType())) // Check if type of given espression matches expected type.
    {
      if (t != NULL) // If token is not given, set token.
      {
        *t = e->GetToken();
      }
      if (msg != NULL) // Set error message.
      {
        *msg = "return type mismatch.";
      }
      return false;
    }
  }
  
  return true;
}

const CType* CAstStatReturn::GetType(void) const
{
  const CType *t = NULL;

  if (GetExpression() != NULL) {
    t = GetExpression()->GetType();
  } else {
    t = CTypeManager::Get()->GetNull();
  }

  return t;
}

ostream& CAstStatReturn::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "return" << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  if (_expr != NULL) _expr->print(out, indent+2);

  return out;
}

string CAstStatReturn::dotAttr(void) const
{
  return " [label=\"return\",shape=box]";
}

void CAstStatReturn::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  if (_expr != NULL) {
    _expr->toDot(out, indent);
    out << ind << dotID() << "->" << _expr->dotID() << ";" << endl;
  }
}

CTacAddr* CAstStatReturn::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStatIf
//
CAstStatIf::CAstStatIf(CToken t, CAstExpression *cond,
                       CAstStatement *ifBody, CAstStatement *elseBody)
  : CAstStatement(t), _cond(cond), _ifBody(ifBody), _elseBody(elseBody)
{
  assert(cond != NULL);
}

CAstExpression* CAstStatIf::GetCondition(void) const
{
  return _cond;
}

CAstStatement* CAstStatIf::GetIfBody(void) const
{
  return _ifBody;
}

CAstStatement* CAstStatIf::GetElseBody(void) const
{
  return _elseBody;
}

bool CAstStatIf::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatIf" << endl;
  // Check1 : Typecheck for if-expression.(should not be NULL)
  // Check2 : Check the type of if-expression matches CBoolType.
  // Check3 : Iteratively typecheck for if-body.
  // Check4 : If else-body exists, iteratively typecheck for else-body.
  CAstExpression* cond = GetCondition(); // Gets the condition of if statement.
  if (cond == NULL) // Condition should not be NULL. This case should not be entered.
  {
    *t = _cond->GetToken(); // Get token for error reporting.
    *msg = "Null condition."; // Set error message.
    return false;
  }
  
  bool condTypeCheckRes = cond->TypeCheck(t, msg); // TypeCheck for condition.
  if (!condTypeCheckRes) // Typecheck for condition fails.
  {
    return false;
  }
  if (!cond->GetType()->Match(CTypeManager::Get()->GetBool())) // Check if condition type is boolean.
  {
    *t = _cond->GetToken(); // Get token for error reporting.
    *msg = "boolean expression expected."; // Set error message.
    return false;
  }
  
  CAstStatement* ifStatSeq = GetIfBody(); // Get if-body.
  bool ifStatSeqTypeCheckRes = true;
  while (ifStatSeqTypeCheckRes && ifStatSeq != NULL) // TypeCheck for if-body statements.
  {
    ifStatSeqTypeCheckRes = ifStatSeq->TypeCheck(t, msg);
    ifStatSeq = ifStatSeq->GetNext();
  }
  if (!ifStatSeqTypeCheckRes) // When at least one statement failed with its typecheck.
  {
    return false;
  }
  
  CAstStatement* elseStatSeq = GetElseBody(); // Get else-body.
  bool elseStatSeqTypeCheckRes = true;
  while (elseStatSeqTypeCheckRes && elseStatSeq != NULL) // If else-body statements exists, TypeCheck them.
  {
    elseStatSeqTypeCheckRes = elseStatSeq->TypeCheck(t, msg);
    elseStatSeq = elseStatSeq->GetNext();
  }
  if (!elseStatSeqTypeCheckRes) // When at least one statement failed with its typecheck.
  {
    return false;
  }
  
  return true;
}

ostream& CAstStatIf::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "if cond" << endl;
  _cond->print(out, indent+2);
  out << ind << "if-body" << endl;
  if (_ifBody != NULL) {
    CAstStatement *s = _ifBody;
    do {
      s->print(out, indent+2);
      s = s->GetNext();
    } while (s != NULL);
  } else out << ind << "  empty." << endl;
  out << ind << "else-body" << endl;
  if (_elseBody != NULL) {
    CAstStatement *s = _elseBody;
    do {
      s->print(out, indent+2);
      s = s->GetNext();
    } while (s != NULL);
  } else out << ind << "  empty." << endl;

  return out;
}

string CAstStatIf::dotAttr(void) const
{
  return " [label=\"if\",shape=box]";
}

void CAstStatIf::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _cond->toDot(out, indent);
  out << ind << dotID() << "->" << _cond->dotID() << ";" << endl;

  if (_ifBody != NULL) {
    CAstStatement *s = _ifBody;
    if (s != NULL) {
      string prev = dotID();
      do {
        s->toDot(out, indent);
        out << ind << prev << " -> " << s->dotID() << " [style=dotted];"
            << endl;
        prev = s->dotID();
        s = s->GetNext();
      } while (s != NULL);
    }
  }

  if (_elseBody != NULL) {
    CAstStatement *s = _elseBody;
    if (s != NULL) {
      string prev = dotID();
      do {
        s->toDot(out, indent);
        out << ind << prev << " -> " << s->dotID() << " [style=dotted];" 
            << endl;
        prev = s->dotID();
        s = s->GetNext();
      } while (s != NULL);
    }
  }
}

CTacAddr* CAstStatIf::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStatWhile
//
CAstStatWhile::CAstStatWhile(CToken t,
                             CAstExpression *cond, CAstStatement *body)
  : CAstStatement(t), _cond(cond), _body(body)
{
  assert(cond != NULL);
}

CAstExpression* CAstStatWhile::GetCondition(void) const
{
  return _cond;
}

CAstStatement* CAstStatWhile::GetBody(void) const
{
  return _body;
}

bool CAstStatWhile::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatWhile" << endl;
  // Check1 : Check if condition exists.
  // Check2 : Typecheck for condition. Check if type is bool.
  // Check3 : Typecheck for statement sequences.
  CAstExpression* cond = GetCondition(); // Get condition. Should not be NULL. This case should not be entered.
  if (cond == NULL)
  {
    *t = cond->GetToken(); // Get token for error reporting.
    *msg = "Null condition."; // Set error message.
    return false;
  }
  
  bool condTypeCheckRes = cond->TypeCheck(t, msg); // TypeCheck the condition.
  if (!condTypeCheckRes) // When typecheck for condition fails.
  {
    return false;
  }
  
  if (!cond->GetType()->Match(CTypeManager::Get()->GetBool())) // Check if condition type is boolean.
  {
    *t = _cond->GetToken(); // Get token for error reporting.
    *msg = "boolean expression expected."; // Set error message.
    return false;
  }
  
  CAstStatement* bodyStatSeq = GetBody(); // Get statements for while-body.
  bool bodyStatSeqTypeCheckRes = true;
  while (bodyStatSeqTypeCheckRes && bodyStatSeq != NULL) // TypeCheck the while-body.
  {
    bodyStatSeqTypeCheckRes = bodyStatSeq->TypeCheck(t, msg);
    bodyStatSeq = bodyStatSeq->GetNext();
  }
  if (!bodyStatSeqTypeCheckRes) // At least one statement failed with its typecheck.
  {
    return false;
  }
  
  return true;
}

ostream& CAstStatWhile::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "while cond" << endl;
  _cond->print(out, indent+2);
  out << ind << "while-body" << endl;
  if (_body != NULL) {
    CAstStatement *s = _body;
    do {
      s->print(out, indent+2);
      s = s->GetNext();
    } while (s != NULL);
  }
  else out << ind << "  empty." << endl;

  return out;
}

string CAstStatWhile::dotAttr(void) const
{
  return " [label=\"while\",shape=box]";
}

void CAstStatWhile::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _cond->toDot(out, indent);
  out << ind << dotID() << "->" << _cond->dotID() << ";" << endl;

  if (_body != NULL) {
    CAstStatement *s = _body;
    if (s != NULL) {
      string prev = dotID();
      do {
        s->toDot(out, indent);
        out << ind << prev << " -> " << s->dotID() << " [style=dotted];"
            << endl;
        prev = s->dotID();
        s = s->GetNext();
      } while (s != NULL);
    }
  }
}

CTacAddr* CAstStatWhile::ToTac(CCodeBlock *cb, CTacLabel *next)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstExpression
//
CAstExpression::CAstExpression(CToken t)
  : CAstNode(t)
{
}

CTacAddr* CAstExpression::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstExpression::ToTac(CCodeBlock *cb,
                                CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstOperation
//
CAstOperation::CAstOperation(CToken t, EOperation oper)
  : CAstExpression(t), _oper(oper)
{
}

EOperation CAstOperation::GetOperation(void) const
{
  return _oper;
}


//------------------------------------------------------------------------------
// CAstBinaryOp
//
CAstBinaryOp::CAstBinaryOp(CToken t, EOperation oper,
                           CAstExpression *l,CAstExpression *r)
  : CAstOperation(t, oper), _left(l), _right(r)
{
  // these are the only binary operation we support for now
  assert((oper == opAdd)        || (oper == opSub)         ||
         (oper == opMul)        || (oper == opDiv)         ||
         (oper == opAnd)        || (oper == opOr)          ||
         (oper == opEqual)      || (oper == opNotEqual)    ||
         (oper == opLessThan)   || (oper == opLessEqual)   ||
         (oper == opBiggerThan) || (oper == opBiggerEqual)
        );
  assert(l != NULL);
  assert(r != NULL);
}

CAstExpression* CAstBinaryOp::GetLeft(void) const
{
  return _left;
}

CAstExpression* CAstBinaryOp::GetRight(void) const
{
  return _right;
}

bool CAstBinaryOp::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStatAssign" << endl;
  
  // Check1 : Typecheck for lhs, rhs.
  // Check2 : Check if GetType returns NULL. If NULL, types are different for lhs and rhs.
  bool lhsTypeCheck = GetLeft()->TypeCheck(t, msg); // TypeCheck the LHS.
  if (!lhsTypeCheck) // If there is failed type check, return false.
  {
    return false;
  }
  bool rhsTypeCheck = GetRight()->TypeCheck(t, msg); // TypeCheck the RHS.
  if (!rhsTypeCheck) // If there is failed type check, return false.
  {
    return false;
  }
  
  const CType* getTypeRes = GetType(); // GetType will return NULL when lhs and rhs are different.
  if (getTypeRes == NULL)
  {
    *t = GetToken(); // Get token for error reporting.
    
    std::stringstream ssLeft; // Get stringstream for LHS.
    ssLeft << GetLeft()->GetType(); // Write type of LHS to stringstream.
    std::stringstream ssRight; // Get stringstream for RHS.
    ssRight << GetRight()->GetType(); // Write type of RHS to stringstream.
    
    string opStr = ""; // (This line and below if-else) Gets operation type and set operation string to appropriate one.
    if (GetOperation() == opAdd) { opStr = "add"; }
    else if (GetOperation() == opSub) { opStr = "sub"; }
    else if (GetOperation() == opMul) { opStr = "mul"; }
    else if (GetOperation() == opDiv) { opStr = "div"; }
    else if (GetOperation() == opAnd) { opStr = "and"; }
    else if (GetOperation() == opOr) { opStr = "or"; }
    else if (GetOperation() == opEqual) { opStr = "equal"; }
    else if (GetOperation() == opNotEqual) { opStr = "notequal"; }
    else if (GetOperation() == opBiggerEqual) { opStr = "biggerequal"; }
    else if (GetOperation() == opBiggerThan) { opStr = "biggerthan"; }
    else if (GetOperation() == opLessEqual) { opStr = "lessequal"; }
    else if (GetOperation() == opLessThan) { opStr = "lessthan"; }
    else { opStr = "invalid"; }
    
    *msg = opStr + ": type mismatch.\n" + "  " + "left  operand: " + ssLeft.str() + "\n  " + "right operand: " + ssRight.str();
    return false;
  }
  
  return true;
}

const CType* CAstBinaryOp::GetType(void) const
{
  EOperation _operator = GetOperation(); // Performed operation.
  if (_operator == opAdd || _operator == opSub || _operator == opMul || _operator == opDiv) // When integer/char operator.
  {
    if (GetLeft()->GetType() == NULL || GetRight()->GetType() == NULL || !GetLeft()->GetType()->Match(GetRight()->GetType())) // If LHS or RHS is NULL.
    {
      return NULL;
    }
    return GetLeft()->GetType(); // When LHS and RHS are both non-NULL.
  }
  else // When boolean operator.
  {
    if (GetLeft()->GetType() == NULL || GetRight()->GetType() == NULL || !GetLeft()->GetType()->Match(GetRight()->GetType())) // If LHS or RHS is NULL.
    {
      return NULL;
    }
    return CTypeManager::Get()->GetBool(); // When LHS and RHS are both non-NULL.
  }
}

ostream& CAstBinaryOp::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << GetOperation() << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  _left->print(out, indent+2);
  _right->print(out, indent+2);

  return out;
}

string CAstBinaryOp::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << GetOperation() << "\",shape=box]";
  return out.str();
}

void CAstBinaryOp::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _left->toDot(out, indent);
  out << ind << dotID() << "->" << _left->dotID() << ";" << endl;
  _right->toDot(out, indent);
  out << ind << dotID() << "->" << _right->dotID() << ";" << endl;
}

CTacAddr* CAstBinaryOp::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstBinaryOp::ToTac(CCodeBlock *cb,
                              CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstUnaryOp
//
CAstUnaryOp::CAstUnaryOp(CToken t, EOperation oper, CAstExpression *e)
  : CAstOperation(t, oper), _operand(e)
{
  assert((oper == opNeg) || (oper == opPos) || (oper == opNot));
  assert(e != NULL);
}

CAstExpression* CAstUnaryOp::GetOperand(void) const
{
  return _operand;
}

bool CAstUnaryOp::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstUnaryOp" << endl;
  // Check1 : Typecheck for operand.
  bool operandTypeCheckRes = GetOperand()->TypeCheck(t, msg); // TypeCheck the operand.
  if (!operandTypeCheckRes)
  {
    return false;
  }
  
  const CType* operandGetTypeRes = GetType(); // Operand should not be NULL.
  if (operandGetTypeRes == NULL)
  {
    *msg = "Unary type is not valid.";
    return false;
  }
  
  if (GetOperation() == opNeg) // Case when operation is negation.
  {
    if (!operandGetTypeRes->IsInt()) // If operand is not type of integer, error.
    {
      std::stringstream ss;
      ss << GetOperand()->GetType();
      *msg = "neg: type mismatch.\n";
      *msg += "  operand:       ";
      *msg += ss.str();
      *t = GetToken();
      return false;
    }
  }
  
  if (GetOperation() == opPos) // Case when operation is positive.
  {
    if (!operandGetTypeRes->IsInt()) // If operand is not type of integer, error.
    {
      std::stringstream ss;
      ss << GetOperand()->GetType();
      *msg = "pos: type mismatch.\n";
      *msg += "  operand:       ";
      *msg += ss.str();
      *t = GetToken();
      return false;
    }
  }
  
  if (GetOperation() == opNot) // Case when operation is boolean-not.
  {
    if (!operandGetTypeRes->IsBoolean()) // If operand is not type of boolean, error.
    {
      std::stringstream ss;
      ss << GetOperand()->GetType();
      *msg = "not: type mismatch.\n";
      *msg += "  operand:       ";
      *msg += ss.str();
      *t = GetToken();
      return false;
    }
  }
  
  return true;
}

const CType* CAstUnaryOp::GetType(void) const
{
  if (GetOperation() == opNeg || GetOperation() == opPos) // When integer/char operator.
  {
    return GetOperand()->GetType();
    //return CTypeManager::Get()->GetInt();
  }
  else // When boolean operator.
  {
    return GetOperand()->GetType();
    //return CTypeManager::Get()->GetBool();
  }
}

ostream& CAstUnaryOp::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << GetOperation() << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";
  out << endl;

  _operand->print(out, indent+2);

  return out;
}

string CAstUnaryOp::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << GetOperation() << "\",shape=box]";
  return out.str();
}

void CAstUnaryOp::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _operand->toDot(out, indent);
  out << ind << dotID() << "->" << _operand->dotID() << ";" << endl;
}

CTacAddr* CAstUnaryOp::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstUnaryOp::ToTac(CCodeBlock *cb,
                             CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstSpecialOp
//
CAstSpecialOp::CAstSpecialOp(CToken t, EOperation oper, CAstExpression *e,
                             const CType *type)
  : CAstOperation(t, oper), _operand(e), _type(type)
{
  assert((oper == opAddress) || (oper == opDeref) || (oper = opCast));
  assert(e != NULL);
  assert(((oper != opCast) && (type == NULL)) ||
         ((oper == opCast) && (type != NULL)));
}

CAstExpression* CAstSpecialOp::GetOperand(void) const
{
  return _operand;
}

bool CAstSpecialOp::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstSpecialOp" << endl;
  CAstExpression* opnd = GetOperand(); // Get operand of this operator.
  //cout << "===(DEBUG)===TypeCheck at CAstSpecialOp - operand is : " << opnd->GetToken().GetValue() << endl;
  
  if (!opnd->GetType()->IsArray()) // This if statement is not used anymore.
  {
    //cout << "===(DEBUG)===TypeCheck at CAstSpecialOp - operand is not type of array." << endl;
  }
  
  bool operandTypeCheckRes = opnd->TypeCheck(t, msg); // TypeChecks operand.
  if (!operandTypeCheckRes)
  {
    return false;
  }
  
  const CType* operandGetTypeRes = GetType(); // Get the type of operand. GetType() will return NULL when it is neither array nor pointer to array.
  if (operandGetTypeRes == NULL)
  {
    *msg = "Operand is not Array type.";
  }
  
  return true;
}

const CType* CAstSpecialOp::GetType(void) const
{
  if (GetOperand()->GetType()->IsPointer()) // When type is pointer. This should NOT OCCUR in parser phase.
  {
    const CArrayType* at = dynamic_cast<const CArrayType*>(dynamic_cast<const CPointerType*>(GetOperand()->GetType())->GetBaseType());
    if (at != NULL)
    {
      
      int idxCnt = at->GetNDim();
      bool typeFin = false;
      for (; idxCnt > 0 && !typeFin; idxCnt--)
      {
        if (!at->GetBaseType()->IsArray())
        {
          typeFin = true;
        }
        else
        {
          at = dynamic_cast<const CArrayType*>(at->GetBaseType());
        }
      }
      return at->GetBaseType();
    }
    else
    {
      return NULL;
    }
  }
  else if (GetOperand()->GetType()->IsArray() && GetOperation() == opAddress) // When type is array.
  {
    CAstExpression* _op = GetOperand();
    return CTypeManager::Get()->GetPointer(GetOperand()->GetType()); // Return pointer to array.
  }
  else // Invalid input. Return NULL.
  {
    return NULL;
  }
}

ostream& CAstSpecialOp::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << GetOperation() << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";
  out << endl;

  _operand->print(out, indent+2);

  return out;
}

string CAstSpecialOp::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << GetOperation() << "\",shape=box]";
  return out.str();
}

void CAstSpecialOp::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  _operand->toDot(out, indent);
  out << ind << dotID() << "->" << _operand->dotID() << ";" << endl;
}

CTacAddr* CAstSpecialOp::ToTac(CCodeBlock *cb)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstFunctionCall
//
CAstFunctionCall::CAstFunctionCall(CToken t, const CSymProc *symbol)
  : CAstExpression(t), _symbol(symbol)
{
  assert(symbol != NULL);
}

const CSymProc* CAstFunctionCall::GetSymbol(void) const
{
  return _symbol;
}

void CAstFunctionCall::AddArg(CAstExpression *arg)
{
  _arg.push_back(arg);
}

int CAstFunctionCall::GetNArgs(void) const
{
  return (int)_arg.size();
}

CAstExpression* CAstFunctionCall::GetArg(int index) const
{
  assert((index >= 0) && (index < _arg.size()));
  return _arg[index];
}

bool CAstFunctionCall::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstFunctionCall" << endl;
  // Check1 : Perform Typecheck for each arguments.
  // Check2 : Check for parameter number count with formal ones.
  // Check3 : Check whether arguments' type matches formal type of procedure/function.
  // Check4 : Check for scalar type return value type, i.e. return value type should not be array.
  if (GetNArgs() != GetSymbol()->GetNParams()) // Check if number of parameters needed matches provided.
  {
    *msg = "Parameter-Argument count mismatch.";
    return false;
  }
  
  int argCnt = GetNArgs(); // Number of arguments given.
  bool argTypeCheckRes = true;
  for (int cnt = 0; argTypeCheckRes && cnt < argCnt; cnt++) // TypeChecks each arguments.
  {
    CAstExpression* arg = GetArg(cnt);
    //cout << "===(DEBUG)===TypeCheck at CAstFunctionCall - arg is : " << arg->GetToken().GetValue() << endl;
    argTypeCheckRes = argTypeCheckRes && arg->TypeCheck(t, msg);
  }
  if (!argTypeCheckRes) // At least one of argument failed with its typecheck.
  {
    return false;
  }
  
  bool argTypeMatchRes = true;
  int cnt = 0;
  for (cnt = 0; argTypeMatchRes && cnt < argCnt; cnt++) // Checks if each argument type matches with expected type.
  {
    CAstExpression* arg = GetArg(cnt);
    //cout << "===(DEBUG)===TypeCheck at CAstFunctionCall - arg is : " << arg->GetToken().GetValue() << endl;
    const CType* argType = arg->GetType(); // Type of given argument.
    const CType* paramType = GetSymbol()->GetParam(cnt)->GetDataType(); // Type of expected parameter.
    //if (!argType->Match(paramType))
    if (!paramType->Match(argType))
    {
      *t = arg->GetToken(); // Set token for error reporting to current(type-mismatched) token.
      argTypeMatchRes = false;
    }
  }
  if (!argTypeMatchRes) // At least one of argument does not meet the expected type.
  {
    const CSymParam* argExpected = GetSymbol()->GetParam(cnt-1); // Get the symbol for expected parameter.
    CAstExpression* argGot = GetArg(cnt-1); // Get the argument given.
    std::stringstream ssExpected; // Stringstream for expected parameter.
    ssExpected << argExpected->GetDataType(); // Write the type of expected parameter.
    std::stringstream ssGot; // Stringstream for argument given.
    ssGot << argGot->GetType(); // Write the type of given argument.
    *msg = "parameter " + to_string(cnt) + ": argument type mismatch.\n" + "  expected " + ssExpected.str() + "\n  " + "got      " + ssGot.str();
    return false;
  }
  
  //const CSymProc* procSym = GetSymbol();
  //cout << "===(DEBUG)===TypeCheck at CAstFunctionCall - symbol name is : " << procSym->GetName() << endl;
  
  return true;
}

const CType* CAstFunctionCall::GetType(void) const
{
  return GetSymbol()->GetDataType();
}

ostream& CAstFunctionCall::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << "call " << _symbol << " ";
  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";
  out << endl;

  for (size_t i=0; i<_arg.size(); i++) {
    _arg[i]->print(out, indent+2);
  }

  return out;
}

string CAstFunctionCall::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"call " << _symbol->GetName() << "\",shape=box]";
  return out.str();
}

void CAstFunctionCall::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  for (size_t i=0; i<_arg.size(); i++) {
    _arg[i]->toDot(out, indent);
    out << ind << dotID() << "->" << _arg[i]->dotID() << ";" << endl;
  }
}

CTacAddr* CAstFunctionCall::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstFunctionCall::ToTac(CCodeBlock *cb,
                                  CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}



//------------------------------------------------------------------------------
// CAstOperand
//
CAstOperand::CAstOperand(CToken t)
  : CAstExpression(t)
{
}


//------------------------------------------------------------------------------
// CAstDesignator
//
CAstDesignator::CAstDesignator(CToken t, const CSymbol *symbol)
  : CAstOperand(t), _symbol(symbol)
{
  assert(symbol != NULL);
}

const CSymbol* CAstDesignator::GetSymbol(void) const
{
  return _symbol;
}

bool CAstDesignator::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstDesignator. CToken : <" << t->GetValue() << ">" << endl;
  return true;
}

const CType* CAstDesignator::GetType(void) const
{
  return GetSymbol()->GetDataType();
}

ostream& CAstDesignator::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << _symbol << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  return out;
}

string CAstDesignator::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << _symbol->GetName();
  out << "\",shape=ellipse]";
  return out.str();
}

void CAstDesignator::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);
}

CTacAddr* CAstDesignator::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstDesignator::ToTac(CCodeBlock *cb,
                                CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstArrayDesignator
//
CAstArrayDesignator::CAstArrayDesignator(CToken t, const CSymbol *symbol)
  : CAstDesignator(t, symbol), _done(false), _offset(NULL)
{
}

void CAstArrayDesignator::AddIndex(CAstExpression *idx)
{
  assert(!_done);
  _idx.push_back(idx);
}

void CAstArrayDesignator::IndicesComplete(void)
{
  assert(!_done);
  _done = true;
}

int CAstArrayDesignator::GetNIndices(void) const
{
  return (int)_idx.size();
}

CAstExpression* CAstArrayDesignator::GetIndex(int index) const
{
  assert((index >= 0) && (index < _idx.size()));
  return _idx[index];
}

bool CAstArrayDesignator::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstArrayDesignator" << endl;
  bool result = true;
  
  if (!GetSymbol()->GetDataType()->IsArray() && !GetSymbol()->GetDataType()->IsPointer()) // Type of symbol should be one of pointer to array(parameter) or array(otherwise).
  {
    *t = GetToken(); // Get the token for error reporting.
    *msg = "invalid array expression."; // Set error message.
    return false;
  }

  int providedDim = GetNIndices(); // Get number of indices given.
  int idxTypeCheckCnt = 0;
  for (idxTypeCheckCnt = 0; idxTypeCheckCnt < providedDim; idxTypeCheckCnt++) // Check if given indices have type(computed) of integer.
  {
    CAstExpression* curIdx = GetIndex(idxTypeCheckCnt); // Get index.
    if (!curIdx->GetType()->IsInt()) // When given expression for index is not type of integer.
    {
      *t = curIdx->GetToken(); // Get the token for error reporting.
      *msg = "invalid array index expression."; // Set error message.
      return false;
    }
  }

  assert(_done); // Adding indices should be finished.

  return result;
}

const CType* CAstArrayDesignator::GetType(void) const
{
  const CSymbol* sym = GetSymbol(); // Symbol for array.
  int idxCnt = GetNIndices(); // Get number of indices.
  const CArrayType* at = dynamic_cast<const CArrayType*>(GetSymbol()->GetDataType()); // Check for given symbol is array.
  if (at == NULL && GetSymbol()->GetDataType()->IsPointer()) // If given symbol is not array, but is pointer to array.
  {
    at = dynamic_cast<const CArrayType*>(dynamic_cast<const CPointerType*>(GetSymbol()->GetDataType())->GetBaseType()); // Dereference it.
  }
  bool idxEnd = false;
  
  if (at == NULL) // Nor array or pointer to array.
  {
    //return CTypeManager::Get()->GetNull();
    return NULL;
  }
  
  for (; idxCnt > 0 && !idxEnd; idxCnt--) // Iterates through indices and get while indices lasts.
  {
    if (at->GetInnerType()->IsArray()) // At least two dimension array. Go to inner array.
    {
      at = dynamic_cast<const CArrayType*>(at->GetInnerType());
    }
    else if (at->GetInnerType()->IsBoolean() && idxCnt == 1) // Got to the base type and base type is boolean.
    {
      return dynamic_cast<const CBoolType*>(at->GetInnerType());
    }
    else if (at->GetInnerType()->IsChar() && idxCnt == 1) // Got to the base type and base type is char.
    {
      return dynamic_cast<const CCharType*>(at->GetInnerType());
    }
    else if (at->GetInnerType()->IsInt() && idxCnt == 1) // Got to the base type and base type is integer.
    {
      return dynamic_cast<const CIntType*>(at->GetInnerType());
    }
    else
    {
      idxEnd = true;
    }
  }
  if (GetNIndices() > 0) // If at least one index is given, return appropriate inner type computed in above for-loop.
  {
    return at;
  }
  else // If no index is given, Just return the type of array.
  {
    return GetSymbol()->GetDataType();
  }
}

ostream& CAstArrayDesignator::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << _symbol << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  for (size_t i=0; i<_idx.size(); i++) {
    _idx[i]->print(out, indent+2);
  }

  return out;
}

string CAstArrayDesignator::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << _symbol->GetName() << "[]\",shape=ellipse]";
  return out.str();
}

void CAstArrayDesignator::toDot(ostream &out, int indent) const
{
  string ind(indent, ' ');

  CAstNode::toDot(out, indent);

  for (size_t i=0; i<_idx.size(); i++) {
    _idx[i]->toDot(out, indent);
    out << ind << dotID() << "-> " << _idx[i]->dotID() << ";" << endl;
  }
}

CTacAddr* CAstArrayDesignator::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstArrayDesignator::ToTac(CCodeBlock *cb,
                                     CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstConstant
//
CAstConstant::CAstConstant(CToken t, const CType *type, long long value)
  : CAstOperand(t), _type(type), _value(value)
{
}

void CAstConstant::SetValue(long long value)
{
  _value = value;
}

long long CAstConstant::GetValue(void) const
{
  return _value;
}

string CAstConstant::GetValueStr(void) const
{
  ostringstream out;

  if (GetType() == CTypeManager::Get()->GetBool()) {
    out << (_value == 0 ? "false" : "true");
  } else {
    out << dec << _value;
  }

  return out.str();
}

bool CAstConstant::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstConstant" << endl;
  return true;
}

const CType* CAstConstant::GetType(void) const
{
  return _type;
}

ostream& CAstConstant::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << GetValueStr() << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  return out;
}

string CAstConstant::dotAttr(void) const
{
  ostringstream out;
  out << " [label=\"" << GetValueStr() << "\",shape=ellipse]";
  return out.str();
}

CTacAddr* CAstConstant::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstConstant::ToTac(CCodeBlock *cb,
                                CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


//------------------------------------------------------------------------------
// CAstStringConstant
//
int CAstStringConstant::_idx = 0;

CAstStringConstant::CAstStringConstant(CToken t, const string value,
                                       CAstScope *s)
  : CAstOperand(t)
{
  CTypeManager *tm = CTypeManager::Get();

  _type = tm->GetArray(strlen(CToken::unescape(value).c_str())+1,
                       tm->GetChar());
  _value = new CDataInitString(value);

  ostringstream o;
  o << "_str_" << ++_idx;

  _sym = new CSymGlobal(o.str(), _type);
  _sym->SetData(_value);
  s->GetSymbolTable()->AddSymbol(_sym);
}

const string CAstStringConstant::GetValue(void) const
{
  return _value->GetData();
}

const string CAstStringConstant::GetValueStr(void) const
{
  return GetValue();
}

bool CAstStringConstant::TypeCheck(CToken *t, string *msg) const
{
  //cout << "===(DEBUG)===TypeCheck at CAstStringConstant" << endl;
  return true;
}

const CType* CAstStringConstant::GetType(void) const
{
  return CTypeManager::Get()->GetArray(CToken::unescape(GetValue()).size()+1, CTypeManager::Get()->GetChar()); // String is array of characters. Not open.
}

ostream& CAstStringConstant::print(ostream &out, int indent) const
{
  string ind(indent, ' ');

  out << ind << '"' << GetValueStr() << '"' << " ";

  const CType *t = GetType();
  if (t != NULL) out << t; else out << "<INVALID>";

  out << endl;

  return out;
}

string CAstStringConstant::dotAttr(void) const
{
  ostringstream out;
  // the string is already escaped, but dot requires double escaping
  out << " [label=\"\\\"" << CToken::escape(GetValueStr())
      << "\\\"\",shape=ellipse]";
  return out.str();
}

CTacAddr* CAstStringConstant::ToTac(CCodeBlock *cb)
{
  return NULL;
}

CTacAddr* CAstStringConstant::ToTac(CCodeBlock *cb,
                                CTacLabel *ltrue, CTacLabel *lfalse)
{
  return NULL;
}


