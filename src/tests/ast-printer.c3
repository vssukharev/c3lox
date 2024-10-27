
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


module test;
import c3lox, std::io;

// fn void! printer1() @test
// {
//   io::printn();
//
//   Tokens tokens;
//   tokens.new_init();
//   
//   TokenKey lit1_i = tokens.push_value(0, TokenKind.NUMBER, (TokenNumber) 2);
//   TokenKey lit2_i = tokens.push_value(0, TokenKind.NUMBER, (TokenNumber) 4);
//   TokenKey oper_i = tokens.push(0, TokenKind.PLUS);;
//   
//   Exprs exprs;
//   exprs.new_init();
//
//   LiteralExpr lit1 = { lit1_i };
//   LiteralExpr lit2 = { lit2_i };
//   ExprKey expr1_i = exprs.push(lit1);
//   ExprKey expr2_i = exprs.push(lit2);
//
//   BinaryExpr oper = { expr1_i, expr2_i, oper_i };
//   exprs.push(oper);
// }


