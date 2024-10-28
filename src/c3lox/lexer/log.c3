
module c3lox::lexer;
import std::io;

fn void Tokens.print(&self)
{
  const String TOKENS_HEADER_START = "----- Tokens ";
  const String KEY_HEADER = "key";
  const String LINE_HEADER = "line";
  const String KIND_HEADER = "kind";
  const String VALUE_HEADER = "value";

  const int MAX_CHARS_KEY = 5;
  const int MAX_CHARS_LINE = 5; // >= LINE_HEADER.len
  const int MAX_CHARS_KIND = 10; // >= KIND_HEADER.len
  const int MAX_CHARS_VALUE = 10; // >= VALUE_HEADER.len

  const int ROW_LEN = MAX_CHARS_KEY + MAX_CHARS_LINE + MAX_CHARS_KIND + MAX_CHARS_VALUE;

  // 1st line
  io::print(TOKENS_HEADER_START);
  for (int i = 0; i < ROW_LEN - TOKENS_HEADER_START.len; ++i) {
    io::putchar('-');
  }
  io::printn();

  // 2nd line
  io::print(KEY_HEADER);  
  for (int i = 0; i < MAX_CHARS_KEY - KEY_HEADER.len; ++i) {
    io::putchar(' ');
  }

  io::print(LINE_HEADER);  
  for (int i = 0; i < MAX_CHARS_LINE - LINE_HEADER.len; ++i) {
    io::putchar(' ');
  }

  io::print(KIND_HEADER);  
  for (int i = 0; i < MAX_CHARS_KIND - KIND_HEADER.len; ++i) {
    io::putchar(' ');
  }

  io::print(VALUE_HEADER);
  for (int i = 0; i < MAX_CHARS_VALUE - VALUE_HEADER.len; ++i) {
    io::putchar(' ');
  }
  io::printn();

  // nth line
  for (TokenKey i = 0; i != self.len(); ++i) {
    ulong line = self.get_line(i);
    TokenKind kind = self.get_kind(i);
    TokenValueKey! value_key = self.get_value_key(i);
    
    // print key
    {
      usz str_len = 0;
      if (try print_res = io::printf("%s", i)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::putchar(' ');
        ++j;
      } while (j < MAX_CHARS_KEY - str_len);
    }

    // print line
    {
      usz str_len = 0;
      if (try print_res = io::printf("%s", line)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::putchar(' ');
        ++j;
      } while (j < MAX_CHARS_LINE - str_len);
    }


    // print kind
    {
      usz str_len = 0;
      if (try print_res = io::printf("%s", kind)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::putchar(' ');
        ++j;
      } while (j < MAX_CHARS_KIND - str_len);
    }

    // print value
    if (try value_key) {
      switch (value_key.kind) {
        case TokenKind.STRING:
          io::printf("%s", self.values.strings[value_key.index]);
        case TokenKind.NUMBER:
          io::printf("%s", self.values.numbers[value_key.index]);
        default: break;
      }
    }

    io::printn();
  }

  for (int i = 0; i != ROW_LEN; ++i) {
    io::putchar('-');
  }
  io::printn();
}


