
module c3lox::parser;
import std::io, c3lox::lexer, c3lox::err;

// TODO: get rid of recursion
fn void printExpression(Exprs* exprs, Tokens* tokens, ExprKey key)
{
  // io::eprintfn("_Key: %s, Length: %s_", key, exprs.nodes.len());
  ExprNode node = exprs.nodes[key];

  io::eprint("( ");
  switch (node.type) 
  {
    case BinaryExpr: 
      BinaryExpr expr = (*exprs.values.@field(BinaryExpr))[node.index];
      io::eprintf("%s", tokens.kinds[expr.operator_token].str);
      io::eprint(" ");
      printExpression(exprs, tokens, expr.left_expr);
      io::eprint(" ");
      printExpression(exprs, tokens, expr.right_expr);
    
    case LiteralExpr:
      LiteralExpr expr = (*exprs.values.@field(LiteralExpr))[node.index];
      TokenValueKey val_key = tokens.get_value_key(expr.literal_token)!!; // panic here as it mustn't happen
      lexer::printTokenValue(&tokens.values, val_key);
 
    case GroupingExpr:
      GroupingExpr expr = (*exprs.values.@field(GroupingExpr))[node.index];
      printExpression(exprs, tokens, expr.inner_expr);

    case UnaryExpr:
      UnaryExpr expr = (*exprs.values.@field(UnaryExpr))[node.index];
      io::eprintf("%s", tokens.kinds[expr.operator_token].str);
      io::eprint(" ");
      printExpression(exprs, tokens, expr.right_expr);

    default:
      io::eprint("<UNKNOWN_EXPR>");
  }
  io::eprint(" )");
}


fn void printExpressionRPN(Exprs* exprs, Tokens* tokens, ExprKey key)
{
  // io::eprintfn("_Key: %s, Length: %s_", key, exprs.nodes.len());
  ExprNode node = exprs.nodes[key];

  switch (node.type) 
  {
    case BinaryExpr: 
      BinaryExpr expr = (*exprs.values.@field(BinaryExpr))[node.index];
      printExpressionRPN(exprs, tokens, expr.left_expr);
      io::eprint(" ");
      printExpressionRPN(exprs, tokens, expr.right_expr);
      io::eprint(" ");
      io::eprintf("%s", tokens.kinds[expr.operator_token].str);
    
    case LiteralExpr:
      LiteralExpr expr = (*exprs.values.@field(LiteralExpr))[node.index];
      TokenValueKey val_key = tokens.get_value_key(expr.literal_token)!!; // panic here as it mustn't happen
      lexer::printTokenValue(&tokens.values, val_key);
 
    case GroupingExpr:
      GroupingExpr expr = (*exprs.values.@field(GroupingExpr))[node.index];
      printExpressionRPN(exprs, tokens, expr.inner_expr);

    case UnaryExpr:
      UnaryExpr expr = (*exprs.values.@field(UnaryExpr))[node.index];
      printExpressionRPN(exprs, tokens, expr.right_expr);
      io::eprint(" ");
      io::eprintf("%s", tokens.kinds[expr.operator_token].str);

    default:
      io::eprint("<UNKNOWN_EXPR>");
  }
}

