
module c3lox::parser;
import std::collections::list, c3lox::lexer, std::io;

def BinaryExprList = List(<BinaryExpr>);
struct BinaryExpr 
{
  ExprKey left_expr;
  ExprKey right_expr;
  TokenKind operator;
}

def GroupingExprList = List(<GroupingExpr>);
struct GroupingExpr 
{
  ExprKey inner_expr;
}

def UnaryExprList = List(<UnaryExpr>);
struct UnaryExpr 
{
  ExprKey right_expr;
  TokenKind operator;
}

def LiteralExprList = List(<LiteralExpr>);
struct LiteralExpr 
{
  TokenKey literal_token;
}

