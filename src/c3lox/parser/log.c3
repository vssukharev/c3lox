
module c3lox::parser;
import std::io, c3lox::lexer, c3lox::err;

// TODO: get rid of recursion
fn void printExpression(Exprs* exprs, Tokens* tokens, ExprKey key)
{
  ExprNode node = exprs.nodes[key];

  io::print("( ");
  switch (node.type) 
  {
    case BinaryExpr: 
      BinaryExpr expr = (*exprs.values.@field(BinaryExpr))[node.index];
      io::printf("%s", tokens.kinds[expr.operator_token].str);
      io::putchar(' ');
      printExpression(exprs, tokens, expr.left_expr);
      io::putchar(' ');
      printExpression(exprs, tokens, expr.right_expr);
    
    case LiteralExpr:
      LiteralExpr expr = (*exprs.values.@field(LiteralExpr))[node.index];
      TokenValueKey val_key = tokens.get_value_key(expr.literal_token)!!; // panic here as it mustn't happen
      lexer::printTokenValue(&tokens.values, val_key);
 
    case GroupingExpr:
      GroupingExpr expr = (*exprs.values.@field(GroupingExpr))[node.index];
      printExpression(exprs, tokens, expr.inner_expr);

    case UnaryExpr:
      GroupingExpr expr = (*exprs.values.@field(GroupingExpr))[node.index];
      printExpression(exprs, tokens, expr.inner_expr);

    default:
      io::print("<UNKNOWN_EXPR>");
  }
  io::print(" )");
}

