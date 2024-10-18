
module c3lox::lexer;
import std::collections::list;

union TokenValue
{
  String str;
  int128 num_int;
  double num_float;
}

def TokenValueList = List(<TokenValue>);

