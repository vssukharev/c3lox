
module c3lox::parser;
import c3lox::lexer;

struct ExprValues 
{
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

