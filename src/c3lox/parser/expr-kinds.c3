
module c3lox::parser;
import std::collections::list, c3lox::lexer, std::io;

def BinaryExprList = List(<BinaryExpr>);
struct BinaryExpr 
{
  ExprKey left_expr;
  ExprKey right_expr;
  TokenKey operator_token;
}

def GroupingExprList = List(<GroupingExpr>);
struct GroupingExpr 
{
  ExprKey inner_expr;
}

def UnaryExprList = List(<UnaryExpr>);
struct UnaryExpr 
{
  TokenKey operator_token;
  ExprKey right_expr;
}

def LiteralExprList = List(<LiteralExpr>);
struct LiteralExpr 
{
  TokenKey literal_token;
}

