
module c3lox::lexer;
import std::io;

fn void Tokens.print(&self)
{
  const String HEADER_START = "----- Tokens ";
  const String KEY_HEADER = "key";
  const String LINE_HEADER = "line";
  const String KIND_HEADER = "kind";
  const String VALUE_HEADER = "value";

  const int MAX_CHARS_KEY = 5;
  const int MAX_CHARS_LINE = 5; // >= LINE_HEADER.len
  const int MAX_CHARS_KIND = 12; // >= KIND_HEADER.len
  const int MAX_CHARS_VALUE = 10; // >= VALUE_HEADER.len

  const int ROW_LEN = MAX_CHARS_KEY + MAX_CHARS_LINE + MAX_CHARS_KIND + MAX_CHARS_VALUE;

  // 1st line
  io::eprint(HEADER_START);
  for (int i = 0; i < ROW_LEN - HEADER_START.len; ++i) {
    io::eprint("-");
  }
  io::eprint("\n");

  // 2nd line
  io::eprint(KEY_HEADER);  
  for (int i = 0; i < MAX_CHARS_KEY - KEY_HEADER.len; ++i) {
    io::eprint(" ");
  }

  io::eprint(LINE_HEADER);  
  for (int i = 0; i < MAX_CHARS_LINE - LINE_HEADER.len; ++i) {
    io::eprint(" ");
  }

  io::eprint(KIND_HEADER);  
  for (int i = 0; i < MAX_CHARS_KIND - KIND_HEADER.len; ++i) {
    io::eprint(" ");
  }

  io::eprint(VALUE_HEADER);
  for (int i = 0; i < MAX_CHARS_VALUE - VALUE_HEADER.len; ++i) {
    io::eprint(" ");
  }
  io::eprint("\n");

  // nth line
  for (TokenKey i = 0; i != self.len(); ++i) {
    ulong line = self.lines[i];
    TokenKind kind = self.kinds[i];
    TokenValueKey! value_key = self.get_value_key(i);
    
    // print key
    {
      usz str_len = 0;
      if (try print_res = io::eprintf("%s", i)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::eprint(" ");
        ++j;
      } while (j < MAX_CHARS_KEY - str_len);
    }

    // print line
    {
      usz str_len = 0;
      if (try print_res = io::eprintf("%s", line)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::eprint(" ");
        ++j;
      } while (j < MAX_CHARS_LINE - str_len);
    }


    // print kind
    {
      usz str_len = 0;
      if (try print_res = io::eprintf("%s", kind)) {
        str_len = print_res;
      }

      int j = 0;
      do {
        io::eprint(" ");
        ++j;
      } while (j < MAX_CHARS_KIND - str_len);
    }

    // TODO: make it simpler
    // print value
    if (try value_key) {
      printTokenValue(&self.values, value_key);
    } else {
      io::eprintf("%s", kind.str);
    }

    io::eprint("\n");
  }

  for (int i = 0; i != ROW_LEN; ++i) {
    io::eprint("-");
  }
  io::eprint("\n");
}

// TODO: do it more safe
fn void printTokenValue(TokenValues* token_vals, TokenValueKey val_key) {
  switch (val_key.kind) {
    case STRING: case IDENTIFIER:
      io::eprintf("%s", token_vals.strings[val_key.index]);
    case NUMBER:
      io::eprintf("%.3f", token_vals.numbers[val_key.index]);
    default: break;
  }
}


