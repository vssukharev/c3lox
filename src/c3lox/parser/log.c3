
module c3lox::parser;
import std::io;

fn void Exprs.print(&self)
{
  const String HEADER_START = "----- Expressions ";
  const String KEY_HEADER = "key";
  const String LINE_HEADER = "line";
  const String KIND_HEADER = "kind";
  const String VALUE_HEADER = "value";

  const int MAX_CHARS_KEY = 5;
  const int MAX_CHARS_LINE = 5; // >= LINE_HEADER.len
  const int MAX_CHARS_KIND = 12; // >= KIND_HEADER.len
  const int MAX_CHARS_VALUE = 10; // >= VALUE_HEADER.len

  const int ROW_LEN = MAX_CHARS_KEY + MAX_CHARS_LINE + MAX_CHARS_KIND + MAX_CHARS_VALUE;
}

