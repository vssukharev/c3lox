
module test;
import std::io, c3lox::parser, c3lox::lexer;

// TODO: fix it
fn void exprsPrinter() @test
{
  io::printn();

  Tokens tokens;
  tokens.new_init();
  defer tokens.free();

  Exprs exprs;
  exprs.new_init();
  defer exprs.free();

  TokenKey bin_token_key = tokens.push(1, TokenKind.PLUS);
  TokenKey num1_token_key = tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 2);
  TokenKey num2_token_key = tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 1);

  tokens.print();

  LiteralExpr num1_expr = { num1_token_key };
  LiteralExpr num2_expr = { num2_token_key };

  ExprKey num1_expr_key = exprs.push(num1_expr);
  ExprKey num2_expr_key = exprs.push(num2_expr);

  BinaryExpr bin_expr = { 
    .left_expr = num1_expr_key,
    .right_expr = num2_expr_key,
    .operator_token = bin_token_key,
  };
  
  ExprKey bin_expr_key = exprs.push(bin_expr);

  parser::printExpression(&exprs, &tokens, bin_expr_key);
  io::printn();
}

