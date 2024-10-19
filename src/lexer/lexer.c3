
module c3lox::lexer;
import c3lox::logger, c3lox::err, std::io;

enum Ascii : char (char value) {
  EOF = 26,
}


/**
 * Scans for tokens
 *
 * @param src "Source code"
 *
 * @return! LexerError.UNEXPECTED_CHAR
 */
fn void! scanTokens(Tokens* tokens, char[] src)
{
  bool error_caught;

  uint lex_start = 0; // lexeme start
  uint offset    = 0; // current offset
  uint line      = 1; // current line

  while (!isEOF(offset, src.len)) {
    error_caught = !@ok(scanToken(tokens, &lex_start, &offset, &line, src));
  }

  if (error_caught) return LexerError.UNEXPECTED_CHAR?;
}

/**
 * @param [out] tokens
 * @param [inout] lexem_start "Start of lexem"
 * @param [inout] offset      "Current offset"
 * @param [inout] line        "Current line"
 * @param src                 "Source code"
 *
 * @return! LexerError.UNEXPECTED_CHAR
 */
fn void! scanToken(
  Tokens* tokens, 
  uint* lexem_start, 
  uint* offset, 
  uint* line, 
  char[] src)
{
  char c = src[*offset];
  io::printfn("Read character '%c' at offset %s and line %s", c, *offset, *line);
  defer ++*offset;

  switch (c) {
    case '(': tokens.push(*line, TokenKind.LEFT_PAREN);
    case ')': tokens.push(*line, TokenKind.RIGHT_PAREN);
    case '{': tokens.push(*line, TokenKind.LEFT_BRACE);
    case '}': tokens.push(*line, TokenKind.RIGHT_BRACE);
    case ',': tokens.push(*line, TokenKind.COMMA);
    case '.': tokens.push(*line, TokenKind.DOT);
    case '-': tokens.push(*line, TokenKind.MINUS);
    case '+': tokens.push(*line, TokenKind.PLUS);
    case ';': tokens.push(*line, TokenKind.SEMICOLON);
    case '*': tokens.push(*line, TokenKind.STAR);

    case '!': tokens.push(*line, matchNextChar('=', offset, src) 
      ? TokenKind.BANG_EQUAL : TokenKind.BANG);

    case '=': tokens.push(*line, matchNextChar('=', offset, src)
      ? TokenKind.EQUAL_EQUAL : TokenKind.EQUAL);

    case '<': tokens.push(*line, matchNextChar('=', offset, src)
      ? TokenKind.LESS_EQUAL : TokenKind.LESS);

    case '>': tokens.push(*line, matchNextChar('=', offset, src)
      ? TokenKind.GREATER_EQUAL : TokenKind.GREATER);

    case '/': {
      if (matchNextChar('/', offset, src)) {
        while (!matchLookupNextChar('\n', *offset, src)) ++*offset;
      } else {
        tokens.push(*line, TokenKind.SLASH);
      }
    }

    case ' ':
    case '\r':
    case '\t':
      break;

    case '\n':
      ++*line;

    default: 
      logger::userError(*line, "Unexpected character: ", c);
      return LexerError.UNEXPECTED_CHAR?;
  }

}

/**
 * @param c "Character to match"
 * @param [inout] offset "Current offset"
 * @param src "Source code"
 */
macro bool matchNextChar(
  char c, 
  uint* offset,
  char[] src)
{
  char next_c = readNextChar(offset, src);
  if (next_c == Ascii.EOF.value) return false;
  
  return next_c == c;
}

/**
 * The same as matchNextChar but doesn't 
 * modify the offset
 *
 * @param c "Character to match"
 * @param offset "Current offset"
 * @param src "Source code"
 */
macro bool matchLookupNextChar(
  char c, 
  uint offset,
  char[] src)
{
  char next_c = lookupNextChar(offset, src);
  if (next_c == Ascii.EOF.value) return false;
  
  return next_c == c;
}

/**
 * @param [inout] offset "Current offset"
 * @param src "Source code"
 *
 * @return "26 if it's EOF"
 */
macro char readNextChar(
  uint* offset,
  char[] src)
{
  ++*offset;
  if (isEOF(*offset, src.len)) return Ascii.EOF.value;
  return src[*offset];
}

/**
 * The same as readNextChar but doesn't 
 * modify the offset
 *
 * @param offset "Current offset"
 * @param src "Source code"
 *
 * @return "26 if it's EOF"
 */
macro char lookupNextChar(
  uint offset,
  char[] src)
{
  ++offset;
  if (isEOF(offset, src.len)) return Ascii.EOF.value;
  return src[offset];
}


/**
 * @param offset  "Current offset"
 * @param src_len "Source code length"
 *
 * @return "Whether we should stop our lexer"
 */
macro bool isEOF(uint offset, uint src_len)
{
  return offset >= src_len;
}

