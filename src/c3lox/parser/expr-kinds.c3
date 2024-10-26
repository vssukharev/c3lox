
module c3lox::parser;
import std::collections::list, c3lox::lexer;

struct ExprValues {
  BinaryExprList binary;
  GroupingExprList grouping;
  LiteralExprList literal;
  UnaryExprList unary;
}

/**
 * Initializes ExprValues on heap
 */
fn void ExprValues.new_init(&self, usz capacity = 16)
{
  self.binary.new_init(capacity);
  self.grouping.new_init(capacity);
  self.literal.new_init(capacity);
  self.unary.new_init(capacity);
}

def BinaryExprList = List(<BinaryExpr>);
struct BinaryExpr {
  ExprIndex left_expr_i;
  ExprIndex right_expr_i;
  TokenIndex operator_i;
}

def GroupingExprList = List(<GroupingExpr>);
struct GroupingExpr {
  ExprIndex inner_expr_i;
}

def UnaryExprList = List(<UnaryExpr>);
struct UnaryExpr {
  TokenIndex operator_i;
  ExprIndex right_expr_i;
}

def LiteralExprList = List(<LiteralExpr>);
struct LiteralExpr {
  TokenIndex literal_i;
}


