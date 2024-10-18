
module c3lox::lexer;

struct Lexer
{
  Tokens tokens;
  uint lex_start;
  uint current;
  uint line;
}

fn bool isEnd(uint current_loc, uint src_length)
{
  return current_loc >= src_length;
}

