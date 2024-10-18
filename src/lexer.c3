
module c3lox::lexer;

import std::collections::list;
import std::io;

enum TokenKind : char
{
  COMMA,
}

struct Token (Printable) 
{
  TokenKind kind;
}


fn usz! Token.to_format(&self, Formatter* formatter) @dynamic 
{
  return formatter.printf("%s", self.kind)!;
}

def TokenList = List(<Token>);

fn void! scanTokens(TokenList* list) 
{
}

