//------------------------------------------------------------------------------
/// @brief SnuPL/0 parser
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2016/03/09 Bernhard Egger adapted to SnuPL/1
/// 2016/04/08 Bernhard Egger assignment 2: parser for SnuPL/-1
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

#ifndef __SnuPL_PARSER_H__
#define __SnuPL_PARSER_H__

#include "scanner.h"
#include "symtab.h"
#include "ast.h"


//------------------------------------------------------------------------------
/// @brief parser
///
/// parses a module
///
class CParser {
  public:
    /// @brief constructor
    ///
    /// @param scanner  CScanner from which the input stream is read
    CParser(CScanner *scanner);

    /// @brief parse a module
    /// @retval CAstNode program node
    CAstNode* Parse(void);

    /// @name error handling
    ///@{

    /// @brief indicates whether there was an error while parsing the source
    /// @retval true if the parser detected an error
    /// @retval false otherwise
    bool HasError(void) const { return _abort; };

    /// @brief returns the token that caused the error
    /// @retval CToken containing the error token
    const CToken* GetErrorToken(void) const;

    /// @brief returns a human-readable error message
    /// @retval error message
    string GetErrorMessage(void) const;
    ///@}

  private:
    /// @brief sets the token causing a parse error along with a message
    /// @param t token causing the error
    /// @param message human-readable error message
    void SetError(CToken t, const string message);

    /// @brief consume a token given type and optionally store the token
    /// @param type expected token type
    /// @param token If not null, the consumed token is stored in 'token'
    /// @retval true if a token has been consumed
    /// @retval false otherwise
    bool Consume(EToken type, CToken *token=NULL);


    /// @brief initialize symbol table @a s with predefined procedures and
    ///        global variables
    void InitSymbolTable(CSymtab *s);

    /// @name methods for recursive-descent parsing
    /// @{
      
    /// @brief Scope for module. Takes no parameter.
    /// @retval CAstModule* for module.
    CAstModule*           module(void);

    /// @brief AST node for sequence of statements.
    /// @param s Scope for this sequence of statements.
    /// @retval CAstStatement* Processed statements. May be multiple of them.
    CAstStatement*        statSequence(CAstScope *s);
    
    /// @brief AST node for if statement.
    /// @param s Scope for this if statement.
    /// @retval CAstStatIf* Processed if statement. 
    CAstStatIf*           ifStatement(CAstScope* s);
    
    /// @brief AST node for while statement.
    /// @param s Scope for this while statement.
    /// @retval CAstStatWhile* Processed while statement.
    CAstStatWhile*        whileStatement(CAstScope* s);
    
    /// @brief AST node for return statement.
    /// @param s Scope for this while statement.
    /// @retval CAstStatReturn* Processed return statement.
    CAstStatReturn*       returnStatement(CAstScope* s);

    /// @brief AST node for assignment statement.
    /// @param s Scope for this assignment statement.
    /// @param commonFirst First token for LHS of this assignment. Used to find appropriate symbol.
    /// @retval CAstStatAssign* Processed assignment statement.
    CAstStatAssign*       assignment(CAstScope *s, CToken* commonFirst);

    /// @brief AST node for subroutine call.
    /// @param s Scope for this subroutine call.
    /// @param prevToken Token that will be the name of subroutine(procedure/function).
    /// @param _tm Type manager.
    /// @retval CAstStatCall* Processed statement call.
    CAstStatCall*         subroutineCall(CAstScope* s, CToken* prevToken, CTypeManager* _tm);
    
    /// @brief AST node for expression.
    /// @param s Scope for this expression.
    /// @retval CAstExpression* Processed expression.
    CAstExpression*       expression(CAstScope *s);
    
    /// @brief AST node for simple expression.
    /// @param s Scope for this simple expression.
    /// @retval CAstExpression* Processed simple expression.
    CAstExpression*       simpleexpr(CAstScope *s);
    
    /// @brief AST node for term.
    /// @param s Scope for this term.
    /// @retval CAstExpression* Processed term.
    CAstExpression*       term(CAstScope *s);
    
    /// @brief AST node for this factor.
    /// @param s Scope for this factor.
    /// @retval CAstExpression* Processed factor.
    CAstExpression*       factor(CAstScope *s);

    CAstConstant*         number(void);
    
    /// @brief Function for getting type of variable, parameter or function.
    /// @param _tm Type manager.
    /// @param _isParam Indicator that type is for parameter or not. When _isParam is true and type is array, it will be referenced.
    /// @retval CType* that this function got.
    CType*                type(CTypeManager* _tm, bool _isParam);
    
    /// @brief Gets one type of variables for procedure/function or global module and store them to vector.
    /// @param _scanner Scanner
    /// @param varVec Vector for storing tokens.
    /// @retVal Returns the type of read variables.
    CType* GetVariables(CScanner* _scanner, vector<CToken*>* varVec);
    
    /// @brief Gets one type of parameters for procedure/function.
    /// @param _scanner Scanner
    /// @param _tm Type manager.
    /// @param paramVec parameter vector for one type.
    /// @param originVec Vector for whole parameter, more than one type. Used to check duplication.
    /// @param idx Index of parameter.
    /// @retVal Type of read parameter.
    CType* GetOneTypeParams(CScanner* _scanner, CTypeManager* _tm, vector<CSymParam*>* paramVec, vector<vector<CSymParam*> >* originVec, int idx);
    
    /// @brief Gets parameters for procedure/function.
    /// @param _scanner Scanner.
    /// @param _tm Type manager.
    /// @param paramVec1 Vector for containing parameters read, may contain multiple types.
    /// @param lastIdx Indicates how many parameters are read before this function is called.
    /// @retVal Type of last read parameter. This is not used.
    CType* GetParams(CScanner* _scanner, CTypeManager* _tm, vector<vector<CSymParam*> >* paramVec1, int lastIdx);
    
    /// @brief Gets Array type for given base type. May use recursive call to this function for getting multiple dimension array.
    /// @param _scanner Scanner.
    /// @param _tm Type manager.
    /// @param _baseType Base type that this array will contain.
    /// @retVal Array type of given base type.
    const CType* GenerateArrayType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType, bool _isParam);
    
    const CType* GeneratePointerType(CScanner* _scanner, CTypeManager* _tm, CType* _baseType);
    
    /// @brief Add argument to given function call.
    /// @param s Scope for function call to add parameter.
    /// @param _scanner Scanner.
    /// @param _tm Type manager.
    /// @param _fc Function call to add arguments.
    /// @param nParams Number of parameters that this function call needs.
    void AddArguments(CAstScope* s, CScanner* _scanner, CTypeManager* _tm, CAstFunctionCall* _fc, int nParams);
    
    /// @brief Check parameter duplication for given name string.
    /// @param paramVec Parameter vector that contains parameters read.
    /// @param elemToFind Name of element to check for duplication.
    /// @retVal true when there is duplication.
    /// @retVal false when there is no duplication.
    bool CheckParamDups (vector<vector<CSymParam*> >* paramVec, const string elemToFind);
    
    /// @brief Get the expression with negative or positive operator applied.
    /// @param _lhs Binary operator expression to apply unary operator.
    /// @param _isNeg Indicates whether unary operator to apply is negative.
    /// @param _isPos Indicates whether unary operator to apply is positive._abort
    /// @retVal Expression with unary operator applied.
    CAstExpression* getBinaryLHS(CAstBinaryOp* _lhs, bool _isNeg, bool _isPos);
    
    /// @brief Check if leftmost operand of given binary operator is constant or not.
    /// @param _lhs Binary operator expression to check.
    /// @retVal true when leftmost operand is constant.
    /// @retVal false when leftmost operand is not constant.
    bool isLeftmostConstant(CAstBinaryOp* _lhs);
    
    
        

    /// @}


    CScanner     *_scanner;       ///< CScanner instance
    CAstModule   *_module;        ///< root node of the program
    CToken        _token;         ///< current token

    /// @name error handling
    CToken        _error_token;   ///< error token
    string        _message;       ///< error message
    bool          _abort;         ///< error flag

};

#endif // __SnuPL_PARSER_H__
