
module test;
import c3lox::lexer, std::io;

fn void tokenPrinter() @test 
{
  io::eprint("\n");

  Tokens tokens;
  tokens.new_init();
  defer tokens.free();

  tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 2);
  tokens.push(1, TokenKind.PLUS);
  tokens.push_value(1, TokenKind.NUMBER, (TokenNumber) 4);
  tokens.push(2, TokenKind.MINUS);
  tokens.push_value(2, TokenKind.STRING, (TokenString) "Ahahahah");
  tokens.push(3, TokenKind.EOF);

  tokens.print();
}

