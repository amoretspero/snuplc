//------------------------------------------------------------------------------
/// @brief SnuPL/0 scanner
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2014/09/10 Bernhard Egger assignment 1: scans SnuPL/-1
/// 2016/03/13 Bernhard Egger assignment 1: adapted to modified SnuPL/-1 syntax
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

#include <iostream>
#include <sstream>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <cstdio>

#include "scanner.h"
using namespace std;

//------------------------------------------------------------------------------
// token names
//
#define TOKEN_STRLEN 49

char ETokenName[][TOKEN_STRLEN] = {
  "tDigit",                         ///< a digit
  "tLetter",                        ///< a letter
  
  "tString",                        ///< a string
  
  "tId",                            ///< an identifier
  "tNum",                           ///< a number.
  
  "tBool",                          ///< a boolean value, i.e. true, false.
  "tChar",                          ///< a character value.
  "tConstChar",                     ///< a constant character, i.e. '\t', '\n' and more.
  "tInt",                           ///< an integer value.
  "tComment",                       ///< a single line comment.
  "tWhitespace",                    ///< a whitespace.
  
  "tType",                          ///< a type.
  
  "tTerm",                          ///< '+' or '-' or '||'
  "tFact",                          ///< '*' or '/' or '&&'
  "tRelOp",                         ///< relational operator, i.e. '=', '#', '<', '<=', '>', '>='
  "tAssign",                        ///< assignment operator, i.e. ':='
  
  "tExclam",                        ///< an exclamination mark
  "tSemicolon",                     ///< a semicolon
  "tColon",                         ///< a colon
  "tComma",                         ///< a comma
  "tDot",                           ///< a dot
  "tLBracketRound",                 ///< a left round bracket '('
  "tRBracketRound",                 ///< a right round bracket ')'
  "tLBrace",                        ///< a left brace '{'
  "tRBrace",                        ///< a right brace '}'
  "tLBracket",                      ///< a left bracket '['
  "tRBracket",                      ///< a right bracket ']'
  
  "tModule",                        ///< keyword 'module'
  "tBegin",                         ///< keyword 'begin'
  "tEnd",                           ///< keyword 'end'
  "tTrue",                          ///< keyword 'true',
  "tFalse",                         ///< keyword 'false',
  "tBoolean",                       ///< keyword 'boolean'
  "tCharacter",                     ///< keyword 'character'
  "tInteger",                       ///< keyword 'integer'
  "tIf",                            ///< keyword 'if',
  "tThen",                          ///< keyword 'then',
  "tElse",                          ///< keyword 'else'
  "tWhile",                         ///< keyword 'while'
  "tDo",                            ///< keyword 'do'
  "tReturn",                        ///< keyword 'return'
  "tVar",                           ///< keyword 'var'
  "tProcedure",                     ///< keyword 'procedure'
  "tFunction",                      ///< keyword 'function'

  "tEOF",                           ///< end of file
  "tIOError",                       ///< I/O error
  "tUndefined",                     ///< undefined
};


//------------------------------------------------------------------------------
// format strings used for printing tokens
//

char ETokenStr[][TOKEN_STRLEN] = {
  "tDigit (%s)",                    ///< a digit
  "tLetter (%s)",                   ///< a letter
  
  "tString (%s)",                   ///< a string
  
  "tId (%s)",                       ///< an identifier
  "tNum (%s)",                      ///< a number.
  
  "tBool (%s)",                     ///< a boolean value, i.e. true, false.
  "tChar (%s)",                     ///< a character value.
  "tConstChar (%s)",                ///< a constant character, i.e. '\t', '\n' and more.
  "tInt (%s)",                      ///< an integer value.
  "tComment (%s)",                  ///< a single line comment.
  "tWhitespace (%s)",               ///< a whitespace.
  
  "tType (%s)",                     ///< a type.
  
  "tTerm (%s)",                     ///< '+' or '-' or '||'
  "tFact (%s)",                     ///< '*' or '/' or '&&'
  "tRelOp (%s)",                    ///< relational operator
  "tAssign",                        ///< assignment operator
  
  "tExclam",                        ///< an exclamination mark
  "tSemicolon",                     ///< a semicolon
  "tColon",                         ///< a colon
  "tComma",                         ///< a comma
  "tDot",                           ///< a dot
  "tLBracketRound",                 ///< a left round bracket '('
  "tRBracketRound",                 ///< a right round bracket ')'
  "tLBrace",                        ///< a left brace '{'
  "tRBrace",                        ///< a right brace '}'
  "tLBracket",                      ///< a left bracket '['
  "tRBracket",                      ///< a right bracket ']'
  
  "tModule",                        ///< keyword 'module'
  "tBegin",                         ///< keyword 'begin'
  "tEnd",                           ///< keyword 'end'
  "tTrue",                          ///< keyword 'true',
  "tFalse",                         ///< keyword 'false',
  "tBoolean",                       ///< keyword 'boolean'
  "tCharacter",                     ///< keyword 'character'
  "tInteger",                       ///< keyword 'integer'
  "tIf",                            ///< keyword 'if',
  "tThen",                          ///< keyword 'then',
  "tElse",                          ///< keyword 'else'
  "tWhile",                         ///< keyword 'while'
  "tDo",                            ///< keyword 'do'
  "tReturn",                        ///< keyword 'return'
  "tVar",                           ///< keyword 'var'
  "tProcedure",                     ///< keyword 'procedure'
  "tFunction",                      ///< keyword 'function'

  "tEOF",                           ///< end of file
  "tIOError",                       ///< I/O error
  "tUndefined (%s)",                ///< undefined
};


//------------------------------------------------------------------------------
// reserved keywords
//
pair<const char*, EToken> Keywords[1] =
{
    {"tModule", tModule}
};



//------------------------------------------------------------------------------
// CToken
//
CToken::CToken()
{
  _type = tUndefined;
  _value = "";
  _line = _char = 0;
}

CToken::CToken(int line, int charpos, EToken type, const string value)
{
  _type = type;
  _value = escape(value);
  _line = line;
  _char = charpos;
}

CToken::CToken(const CToken &token)
{
  _type = token.GetType();
  _value = token.GetValue();
  _line = token.GetLineNumber();
  _char = token.GetCharPosition();
}

CToken::CToken(const CToken *token)
{
  _type = token->GetType();
  _value = token->GetValue();
  _line = token->GetLineNumber();
  _char = token->GetCharPosition();
}

const string CToken::Name(EToken type)
{
  return string(ETokenName[type]);
}

const string CToken::GetName(void) const
{
  return string(ETokenName[GetType()]);
}

ostream& CToken::print(ostream &out) const
{
  int str_len = _value.length();
  str_len = TOKEN_STRLEN + (str_len < 64 ? str_len : 64);
  char *str = (char*)malloc(str_len);
  snprintf(str, str_len, ETokenStr[GetType()], _value.c_str());
  out << dec << _line << ":" << _char << ": " << str;
  free(str);
  return out;
}

string CToken::escape(const string text)
{
  const char *t = text.c_str();
  string s;

  while (*t != '\0') {
    switch (*t) {
      case '\n': s += "\\n";  break;
      case '\t': s += "\\t";  break;
      case '\0': s += "\\0";  break;
      case '\'': s += "\\'";  break;
      case '\"': s += "\\\""; break;
      case '\\': s += "\\\\"; break;
      default :  s += *t;
    }
    t++;
  }

  return s;
}

ostream& operator<<(ostream &out, const CToken &t)
{
  return t.print(out);
}

ostream& operator<<(ostream &out, const CToken *t)
{
  return t->print(out);
}


//------------------------------------------------------------------------------
// CScanner
//
map<string, EToken> CScanner::keywords;

CScanner::CScanner(istream *in)
{
  InitKeywords();
  _in = in;
  _delete_in = false;
  _line = _char = 1;
  _token = NULL;
  _good = in->good();
  NextToken();
}

CScanner::CScanner(string in)
{
  InitKeywords();
  _in = new istringstream(in);
  _delete_in = true;
  _line = _char = 1;
  _token = NULL;
  _good = true;
  NextToken();
}

CScanner::~CScanner()
{
  if (_token != NULL) delete _token;
  if (_delete_in) delete _in;
}

void CScanner::InitKeywords(void)
{
  if (keywords.size() == 0) {
    int size = sizeof(Keywords) / sizeof(Keywords[0]);
    for (int i=0; i<size; i++) {
      keywords[Keywords[i].first] = Keywords[i].second;
    }
  }
}

CToken CScanner::Get()
{
  CToken result(_token);

  EToken type = _token->GetType();
  _good = !(type == tIOError);

  NextToken();
  return result;
}

CToken CScanner::Peek() const
{
  return CToken(_token);
}

void CScanner::NextToken()
{
  if (_token != NULL) delete _token;

  _token = Scan();
}

void CScanner::RecordStreamPosition()
{
  _saved_line = _line;
  _saved_char = _char;
}

void CScanner::GetRecordedStreamPosition(int *lineno, int *charpos)
{
  *lineno = _saved_line;
  *charpos = _saved_char;
}

CToken* CScanner::NewToken(EToken type, const string token)
{
  return new CToken(_saved_line, _saved_char, type, token);
}

CToken* CScanner::Scan()
{
  EToken token;
  string tokval;
  char c;

  while (_in->good() && IsWhite(_in->peek())) GetChar();

  RecordStreamPosition();

  if (_in->eof()) return NewToken(tEOF);
  if (!_in->good()) return NewToken(tIOError);

  c = GetChar();
  tokval = c;
  token = tUndefined;

  switch (c) {
    case ':':
      if (_in->peek() == '=') {
        tokval += GetChar();
        token = tAssign;
      }
      else
      {
        token = tColon;
      }
      break;

    case '+':
    case '-':
      token = tTerm;
      break;
    
    case '|':
      if (_in->peek() == '|')
      {
        tokval += GetChar();
        token = tTerm;
      }
      break;

    case '*':
    case '/':
      token = tFact;
      break;
      
    case '&':
      if (_in->peek() == '&')
      {
        tokval += GetChar();
        token = tFact;
      }
      break;

    case '=':
    case '#':
      token = tRelOp;
      break;
    
    case '<':
    case '>':
      if (_in->peek() == '=')
      {
        tokval += GetChar();
        token = tRelOp;
      }
      else
      {
        token = tRelOp;
      }
      break;

    case ';':
      token = tSemicolon;
      break;

    case '.':
      token = tDot;
      break;
      
    case ',':
      token = tComma;
      break;

    case '(':
      token = tLBracketRound;
      break;

    case ')':
      token = tRBracketRound;
      break;
    
    case '{':
      token = tLBrace;
      break;
    
    case '}':
      token = tRBrace;
      break;
    
    case '[':
      token = tLBracket;
      break;
    
    case ']':
      token = tRBracekt;
      break;

    default:
      if (IsDigit(c)) {
        while (IsDigit(_in->peek()))
        {
          tokval += GetChar();
        }
        token = tNum;
      } else
      if (c == '\'')
      {
        tokval = tokval.substr(0, tokval.size() - 1);
        if (_in->peek() == '\\')
        {
          tokval += GetChar();
          if (IsEscape(_in->peek()))
          {
            tokval += GetChar();
            if (_in->peek() == '\'')
            {
              GetChar();
              token = tConstChar;
            }
            else
            {
              token = tUndefined;
            }
          }
        }
        else
        {
          if (_in->peek() == '\'')
          {
            GetChar();
            token = tChar;
          }
          else
          {
            token = tUndefined;
          }
        }
      }
      else {
        tokval = "invalid character '";
        tokval += c;
        tokval += "'";
      }
      break;
  }

  return NewToken(token, tokval);
}

char CScanner::GetChar()
{
  char c = _in->get();
  if (c == '\n') { _line++; _char = 1; } else _char++;
  return c;
}

string CScanner::GetChar(int n)
{
  string str;
  for (int i=0; i<n; i++) str += GetChar();
  return str;
}

bool CScanner::IsWhite(char c) const
{
  return ((c == ' ') || (c == '\n'));
}

bool CScanner::IsDigit(char c) const
{
  return ((c >= '0') && (c <= '9'));
}

bool CScanner::IsEscape(char c) const
{
  return ((c == 'n') || (c == 't') || (c == '0') || (c == '"') || (c == '\'') || (c == '\\'));
}