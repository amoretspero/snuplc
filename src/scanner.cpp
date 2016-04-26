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
#define TOKEN_STRLEN 39

char ETokenName[][TOKEN_STRLEN] = {
  "tString",                        ///< a string
  
  "tId",                            ///< an identifier
  "tNum",                           ///< a number.
  
  "tCharacter",                     ///< a character, for example, 'a', 'b', and more.
  "tConstChar",                     ///< a constant character, i.e. '\t', '\n' and more.
  
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
  "tLBracket",                      ///< a left bracket '['
  "tRBracket",                      ///< a right bracket ']'
  
  "tModule",                        ///< keyword 'module'
  "tBegin",                         ///< keyword 'begin'
  "tEnd",                           ///< keyword 'end'
  "tTrue",                          ///< keyword 'true',
  "tFalse",                         ///< keyword 'false',
  "tBoolean",                       ///< keyword 'boolean'
  "tChar",                          ///< keyword 'character'
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
  "tString (%s)",                   ///< a string
  
  "tId (%s)",                       ///< an identifier
  "tNum (%s)",                      ///< a number.
  
  "tCharacter (%s)",                ///< a character, for example, 'a', 'b, and more.
  "tConstChar (%s)",                ///< a constant character, i.e. '\t', '\n' and more.
  
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
  "tLBracket",                      ///< a left bracket '['
  "tRBracket",                      ///< a right bracket ']'
  
  "tModule",                        ///< keyword 'module'
  "tBegin",                         ///< keyword 'begin'
  "tEnd",                           ///< keyword 'end'
  "tTrue",                          ///< keyword 'true',
  "tFalse",                         ///< keyword 'false',
  "tBoolean",                       ///< keyword 'boolean'
  "tChar",                     			///< keyword 'character'
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
pair<const char*, EToken> Keywords[17] =
{
    {"module", tModule},
    {"begin", tBegin},
    {"end", tEnd},
    {"true", tTrue},
    {"false", tFalse},
    {"boolean", tBoolean},
    {"char", tChar},
    {"integer", tInteger},
    {"if", tIf},
    {"then", tThen},
    {"else", tElse},
    {"while", tWhile},
    {"do", tDo},
    {"return", tReturn},
    {"var", tVar},
    {"procedure", tProcedure},
    {"function", tFunction}
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
  while (_in->peek() == '/')
  {
    if (_in->peek() == '/')
    {
      _in->seekg(1, _in->cur);
      if (_in->peek() == '/')
      {
        _in->seekg(-1, _in->cur);
        while (true)
        {
          int peek_val = _in->peek();
          //if (peek_val != '\n' && peek_val != EOF)
          if (peek_val != '\n' && peek_val != EOF)
          {
            GetChar();
          }
          else
          {
            break;
          }
        }
        while(_in->good() && IsWhite(_in->peek()))
        {
          GetChar();
        }
      }
      else
      {
        _in->seekg(-1, _in->cur);
				break;
      }
    }
  }

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
      token = tFact;
      break;
    case '/':
      if (_in->peek() == '/')
      {
        tokval += GetChar();
        while (true)
        {
          int peek_val = _in->peek();
          if (peek_val != '\n' && peek_val != EOF)
          {
            tokval += GetChar();
          }
          else
          {
            break;
          }
        }
        break;
      }
      else
      {
        token = tFact;
        break;
      }
      
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
      
    case '!':
      token = tExclam;
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
    
    case '[':
      token = tLBracket;
      break;
    
    case ']':
      token = tRBracket;
      break;

    default:
      if (IsDigit(c)) // Number case.
      {
        while (IsDigit(_in->peek()))
        {
          tokval += GetChar();
        }
        token = tNum;
      } 
      else if (c == '\'') // Possibility of character.
      {
        if (_in->peek() == '\\') // Possibility of escape character.
        {
          tokval = tokval.substr(0, tokval.size() - 1); // Remove leading single quote.
          tokval += GetChar(); // Get backslash.
          
          // Check if valid escape character.
          if (IsEscape(_in->peek())) // Case of valid escape character.
          {
            tokval += GetChar();
            
            // Check if single quote is appropriately closed
            if (_in->peek() == '\'') // Case when appropriately closed.
            {
              GetChar();
              token = tConstChar;
              
              // Set token values.
              if (tokval == "\\n")
              {
                tokval = "\n";
              }
              else if (tokval == "\\t")
              {
                tokval = "\t";
              }
              else if (tokval == "\\0")
              {
                tokval = "\0";
              }
              else if (tokval == "\\\"")
              {
                tokval = "\"";
              }
              else if (tokval == "\\'")
              {
                tokval = "'";
              }
              else
              {
                tokval = "\\";
              }
              
            }
            else // Case when not closed appropriately.
            {
              token = tUndefined;
              
              // Get characters until the next character(_in->peek()) is EOF or closing single quote.
              // Escape letters in between are processed appropriately.
              while (true)
              {
                if (_in->peek() != '\'' && _in->peek() != EOF && _in->peek() != '\\')
                {
                  tokval += GetChar();
                }
                else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
                {
                  char processres = ProcessEscape(_in);
                  if (processres == 0)
                  {
                    tokval += GetChar();
                  }
                  else
                  {
                    tokval += processres;
                  }
                }
               else
               {
                 break;
               }
              }
              if (_in->peek() == '\'') // If single quote is closed, does not include it in tokval.
              {
                GetChar();
              }      
            }
          }
          else // Case when not a valid escape character.
          {
            // Get characters until the next character(_in->peek()) is EOF or closing single quote.
            // Escape letters in between are processed appropriately.
            while (true)
            {
              if (_in->peek() != '\'' && _in->peek() != EOF && _in->peek() != '\\')
              {
                tokval += GetChar();
              }
              else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
              {
                char processres = ProcessEscape(_in);
                if (processres == 0)
                {
                  tokval += GetChar();
                }
                else
                {
                  tokval += processres;
                }
              }
              else
              {
                break;
              }
            }
            if (_in->peek() == '\'') // If single quote is closed, does not include it in tokval.
            {
              GetChar();
            }
            token = tUndefined; // Set token type as tUndefined.
          }
        }
        else if (IsAscii(_in->peek())) // Possibility of ASCIIchar ranging from 32 to 126.
        {
          tokval = tokval.substr(0, tokval.size() - 1); // Remove leading single quote.
					if (_in->peek() == '\'') // Empty character case.
					{
						GetChar();
						token = tUndefined;
					}
					else if (IsAscii(_in->peek())) // Possibility of valid character.
					{
          	tokval += GetChar();
            
            // Check if single quote is appropriately closed.
          	if (_in->peek() == '\'') // Case when single quote is appropriately closed.
          	{
            	//tokval = tokval.substr(1, tokval.size() - 1);
            	GetChar();
            	token = tCharacter;
          	}
          	else // Case when single quote is not appropriately closed.
          	{
              // Get characters until the next character(_in->peek()) is EOF or closing single quote.
              // Escape letters in between are processed appropriately.
							while (true)
              {
                if (_in->peek() != '\'' && _in->peek() != EOF && _in->peek() != '\\')
                {
                  tokval += GetChar();
                }
                else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
                {
                  char processres = ProcessEscape(_in);
                  if (processres == 0)
                  {
                    tokval += GetChar();
                  }
                  else
                  {
                    tokval += processres;
                  }
                }
               else
               {
                 break;
               }
              }
              if (_in->peek() == '\'') // If single quote is closed, does not include it in tokval.
              {
                GetChar();
              }
            	token = tUndefined; // Set token type as tUndefined.
          	}
        	}
          else // Case when not a valid character.
          {
            token = tUndefined;

						// Get characters until the next character(_in->peek()) is EOF or closing single quote.
            // Escape letters in between are processed appropriately.
            while (true)
            {
              if (_in->peek() != '\'' && _in->peek() != EOF && _in->peek() != '\\')
              {
                tokval += GetChar();
              }
              else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
              {
                char processres = ProcessEscape(_in);
                if (processres == 0)
                {
                  tokval += GetChar();
                }
                else
                {
                  tokval += processres;
                }
              }
              else
              {
                break;
              }
            }
            if (_in->peek() == '\'') // If single quote is closed, does not include it in tokval.
            {
              GetChar();
            }
          }
				}
        else // Case when invalid characters.
        {
          tokval = tokval.substr(0, tokval.size() - 1); // Remove leading single quote.
          token = tUndefined; // Set token to tUndefined.
          
          // Get characters until the next character(_in->peek()) is EOF or closing single quote.
          // Escape letters in between are processed appropriately.
          while (true)
          {
            if (_in->peek() != '\'' && _in->peek() != EOF && _in->peek() != '\\')
            {
              tokval += GetChar();
            }
            else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
            {
              char processres = ProcessEscape(_in);
              if (processres == 0)
              {
                tokval += GetChar();
              }
              else
              {
                tokval += processres;
              }
            }
            else
            {
              break;
            }
          }
          if (_in->peek() == '\'') // If reached closing single quote, remove it.
          {
            GetChar();
          }
        }
      }
      else if (c == '\"') // Possibility of string.
      {
        tokval = tokval.substr(0, tokval.size() - 1); // Remove leading double quote.
        while (true)
        {
          int peek_val = _in->peek();
          
          // Check if next character is not EOF, closing double quote and is a character.
          if (peek_val != EOF && peek_val != '\"' && IsAscii(peek_val)) // Case when next character is not EOF, closing double quote, and is a character.
          {
            if (peek_val == '\\') // Possibility of escape character.
            {
              _in->seekg(1, _in->cur);
              
              // Check 2 characters ahead to see if it is valid escape character.
              if (IsEscape(_in->peek())) // Case when valid escape character.
              {
                // Set steram pointer to original location and read characters.
                _in->seekg(-1, _in->cur);
                GetChar(); // Consume backslash.
                
                if (_in->peek() == 'n')
                {
                  tokval += '\n';
                }
                else if (_in->peek() == 't')
                {
                  tokval += '\t';
                }
                else if (_in->peek() == '0')
                {
                  tokval += '\0';
                }
                else if (_in->peek() == '\'')
                {
                  tokval += '\'';
                }
                else if (_in->peek() == '"')
                {
                  tokval += '"';
                }
                else
                {
                  tokval += '\\';
                }
                GetChar(); // Consume character.
              }
              else // Case when invalid escape character. Scanner will just scan as it is, i.e. \a as '\\' + 'a'.
              {
                _in->seekg(-1, _in->cur);
                tokval += GetChar();
              }
            }
            else // Case when not an escape character.
            {
              tokval += GetChar();
            }
          }
          else // Meet an EOF or double quote or not an ascii character.
          {
            break;
          }
        }

        if (_in->peek() == EOF) // Case of not closed string meets End of File.
        {
          tokval = "Unexpected end of stream";
        }
				else if (!IsAscii(_in->peek())) // Case when not a character of SnuPL/1 is met.
				{
					token = tUndefined; // Set token type as tUndefined.
          
          // Get characters until the next character(_in->peek()) is EOF or closing double quote.
          // Escape letters in between are processed appropriately.
          while (true)
          {
            if (_in->peek() != '\"' && _in->peek() != EOF && _in->peek() != '\\')
            {
              tokval += GetChar();
            }
            else if (_in->peek() == '\\') // Possibility of escape character. If so, it is processed.
            {
              char processres = ProcessEscape(_in);
              if (processres == 0)
              {
                tokval += GetChar();
              }
              else
              {
                tokval += processres;
              }
            }
            else
            {
              break;
            }
          }
          if (_in->peek() == '\"') // Case when closing double quote is met.
          {
            GetChar(); // Removes closing double quote and prepare to start scanning again.
          }
          else // Case when EOF is met.
          {
            tokval = "Unexpected end of stream";
          }
				}
        else // Case when closing double quote is appropriately met.
        {
          GetChar(); // Remove closing double quote.
          token = tString; // Set token.
        }
      }
      else if (IsLetter(c)) // Possibility of identifier.
      {
          while (true)
          {
              int peek_val = _in->peek();
              if (IsDigit(peek_val) || IsLetter(peek_val)) // Read until character that should not compose an identifier is met.
              {
                  tokval += GetChar();
              }
              else
              {
                  break;
              }
          }
          token = tId; // Set token.
          if (keywords.find(tokval) != keywords.end()) // Check if found identifier is a reserved keyword. If so, set token as that keyword.
          {
              token = keywords.find(tokval)->second;
          }
      }
      else // No token condition is met.
      {
        tokval = "invalid character ";
        tokval += c;
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

bool CScanner::IsLetter(char c) const
{
  return (((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z')) || (c == '_'));
}

bool CScanner::IsEscape(char c) const
{
  return ((c == 'n') || (c == 't') || (c == '0') || (c == '"') || (c == '\'') || (c == '\\'));
}

bool CScanner::IsAscii(char c) const
{
	return (c >= 32 && c <= 126);
}

bool CScanner::IsCharacter(char c) const
{
  return (IsAscii(c) || (c == '\n') || (c == '\t') || (c == '\0') || (c == '\"') || (c == '\'') || (c == '\\'));
}

char CScanner::ProcessEscape(istream* _in)
{
  // Seek two step ahead. One step ahead should be done in caller function.
  _in->seekg(1, _in->cur);
  
  // Check if it is valid escape letter. If so, consume backslash and a character indicating escape, and return appropriate value.
  // If not, return 0. Decision about this should be done in caller function.
  if (IsEscape(_in->peek()))
  {
    if (_in->peek() == 'n')
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\n';
    }
    else if (_in->peek() == 't')
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\t';
    }
    else if (_in->peek() == '0')
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\0';
    }
    else if (_in->peek() == '"')
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\"';
    }
    else if (_in->peek() == '\'')
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\'';
    }
    else
    {
      _in->seekg(-1, _in->cur);
      GetChar();
      GetChar();
      return '\\';
    }
  }
  else
  {
    return 0;
  }
}

string CToken::unescape(const string text)
{
	const char* t = text.c_str();
	string s;

	while (*t != '\0')
	{
		if (*t == '\\')
		{
			switch (*++t)
			{
				case 'n' : s += "\n"; break;
				case 't' : s += "\t"; break;
				case '0' : s += "\0"; break;
				case '\'': s += "'"; break;
				case '"' : s += "\""; break;
				case '\\' : s += "\\"; break;
				default : s += '?';
			}
		}
		else
		{
			s += *t;
		}
		t++;
	}
	return s;
}
