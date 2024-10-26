
module c3lox::lexer;
import std::io;

// /**
//  * @param [&in] exprs
//  * @param expr_index
//  */
// macro void printExpr(Exprs* exprs, ExprIndex expr_index)
// {
//   io::printf("");
// }


module tests;
import c3lox, std::io;

/**
 *
 */
fn void! printer1() @test
{
  io::printn();

  Tokens tokens;
  tokens.new_init();
  
  TokenIndex lit1_i = tokens.push_value(0, TokenKind.NUMBER, (TokenNumber) 2);
  TokenIndex lit2_i = tokens.push_value(0, TokenKind.NUMBER, (TokenNumber) 4);
  TokenIndex oper_i = tokens.push(0, TokenKind.PLUS);;
  
  Exprs exprs;
  exprs.new_init();

  LiteralExpr lit1 = { lit1_i };
  LiteralExpr lit2 = { lit2_i };
  ExprIndex expr1_i = exprs.push(lit1);
  ExprIndex expr2_i = exprs.push(lit2);

  BinaryExpr oper = { expr1_i, expr2_i, oper_i };
  exprs.push(oper);
}


