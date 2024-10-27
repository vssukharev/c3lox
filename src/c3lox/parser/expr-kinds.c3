
module c3lox::parser;
import std::collections::list, c3lox::lexer, std::io;

def BinaryExprList = List(<BinaryExpr>);
struct BinaryExpr 
{
  ExprKey left_expr_i;
  ExprKey right_expr_i;
  TokenKey operator_i;
}

def GroupingExprList = List(<GroupingExpr>);
struct GroupingExpr 
{
  ExprKey inner_expr_i;
}

def UnaryExprList = List(<UnaryExpr>);
struct UnaryExpr 
{
  TokenKey operator_i;
  ExprKey right_expr_i;
}

def LiteralExprList = List(<LiteralExpr>);
struct LiteralExpr 
{
  TokenKey literal_i;
}


