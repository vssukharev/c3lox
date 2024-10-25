
import c3lox::parser;

struct ExprValues {
  BinaryExprList binary;
  GroupingExprList grouping;
  LiteralExprList literal;
  UnaryExprList unary;
}

