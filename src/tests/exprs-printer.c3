
module test;
import std::io, c3lox::parser, c3lox::lexer;

fn void exprsPrinter() @test
{
  io::eprint("\n");

  Tokens tokens;
  tokens.new_init();
  defer tokens.free();

  Exprs exprs;
  exprs.new_init();
  defer exprs.free();

  TokenKey bin_token_key = tokens.push(1, TokenKind.PLUS);
  TokenKey num1_token_key = tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 2);
  TokenKey num2_token_key = tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 1);
  TokenKey semicolon1_token_key = tokens.push(1, TokenKind.SEMICOLON);

  tokens.print();

  ExprKey num1_expr_key = exprs.push(LiteralExpr{num1_token_key});
  ExprKey num2_expr_key = exprs.push(LiteralExpr{num2_token_key});
  
  BinaryExpr bin_expr = { 
    .left_expr = num1_expr_key,
    .right_expr = num2_expr_key,
    .operator_token = bin_token_key,
  };
  
  ExprKey bin_expr_key = exprs.push(bin_expr);
  
  io::eprint("Typical: ");
  parser::printExpression(&exprs, &tokens, bin_expr_key);
  io::eprint("\n");
  io::eprint("RPN: ");
  parser::printExpressionRPN(&exprs, &tokens, bin_expr_key);
  io::eprint("\n");
}

