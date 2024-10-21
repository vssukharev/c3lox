
module c3lox::lexer;
import c3lox::logger, c3lox::err, std::io, std::ascii;

enum Ascii : char (char value) {
  EOF = 26,
}

/**
 * Scans for tokens
 *
 * @param src "Source code"
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! scanTokens(Tokens* tokens, char[] src)
{
  anyfault caught_error;

  uint lex_start = 0; // lexeme start
  uint offset    = 0; // current offset
  uint line      = 1; // current line

  while (!isEOF(offset, src.len)) {
    lex_start = offset;
    caught_error = @catch(scanToken(tokens, &lex_start, &offset, &line, src));
  }

  if (caught_error) return caught_error?;
}

/**
 * @param [out] tokens
 * @param [inout] lexem_start "Start of lexem"
 * @param [inout] offset      "Current offset"
 * @param [inout] line        "Current line"
 * @param src                 "Source code"
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! scanToken(
  Tokens* tokens, 
  uint* lexem_start, 
  uint* offset, 
  uint* line, 
  char[] src)
{
  char c = src[*offset];
  // io::printfn("Read character '%c' at offset %s and line %s", c, *offset, *line);
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

    case '!': tokens.push(*line, lookupNextChar(*offset, src) == '='
      ? TokenKind.BANG_EQUAL : TokenKind.BANG);

    case '=': tokens.push(*line, lookupNextChar(*offset, src) == '='
      ? TokenKind.EQUAL_EQUAL : TokenKind.EQUAL);

    case '<': tokens.push(*line, lookupNextChar(*offset, src) == '='
      ? TokenKind.LESS_EQUAL : TokenKind.LESS);

    case '>': tokens.push(*line, lookupNextChar(*offset, src) == '='
      ? TokenKind.GREATER_EQUAL : TokenKind.GREATER);

    case '/': 
    {
      if (lookupNextChar(*offset, src) == '/') {
        ++*offset;
        char next_c = lookupNextChar(*offset, src);
        while (next_c != '\n' && next_c != Ascii.EOF.value) {
          next_c = lookupNextChar(*offset, src);
          ++*offset;
        }

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

    case '"': 
      tokenizeStringLiteral(tokens, line, offset, src)!;

    default:
      if (isNumStart(c)) {
        tokenizeNumberLiteral(tokens, offset, *line, src);
      } else if (isIdStart(c)) {
        tokenizeIdentifier();
      } else {
        logger::userError(*line, "Unexpected character: ", c);
        return ProgramError.USER_ERROR?;
      }
  }

}


fn void tokenizeIdentifier()
{

}

/**
 * Modifies 'tokens' parameter by pushing 
 * value of string literal into it. 
 *
 * @param [out] tokens "Tokens to be modified"
 * @param [inout] offset "Offset of number start"
 * @param line "Current line"
 * @param src "Source code"
 *
 * @require isNumStart(src[*offset])
 */
fn void tokenizeNumberLiteral(
  Tokens* tokens,
  uint* offset,
  uint line,
  char[] src)
{
  uint lexeme_start = *offset;
  
  while (isDigit(lookupNextChar(*offset, src))) ++*offset;

  // Look for fractional part
  if (lookupNextChar(*offset, src) == '.' && 
      isDigit(lookupNextChar(*offset+1, src)))
  {
    // Consume the "."
    ++*offset;
    while (isDigit(lookupNextChar(*offset, src))) ++*offset;
  }

  String str_value = (String) src[lexeme_start..*offset];
  double value = str_value.to_double()!!; // panic here for now

  tokens.push_value(line, TokenKind.NUMBER, value);
  io::printfn("%s: %s", $$FUNC, value);
}

/**
 * Modifies 'tokens' parameter by pushing 
 * value of string literal into it. 
 *
 * @param [out] tokens "Tokens to be modified"
 * @param [inout] line "Current line"
 * @param [inout] offset "Offset of double quotes character"
 * @param src "Source code"
 *
 * @require src[*offset] == '"'
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! tokenizeStringLiteral(
  Tokens* tokens,
  uint* line, 
  uint* offset,
  char[] src)
{
  uint lexeme_start = *offset;

  char next_c;

  do {
    next_c = lookupNextChar(*offset, src);
    if (next_c == '\n') ++*line;
    ++*offset;

    if (next_c == Ascii.EOF.value) {
      logger::userError(*line, "Reached end of file with unterminated string");
      return ProgramError.USER_ERROR?;
    }
  } while (next_c != '"');


  // Trim the surrounding quotes
  String value = (String) src[lexeme_start+1..*offset];
  tokens.push_value(*line, TokenKind.STRING, value);
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
macro bool isEOF(
  uint offset, 
  uint src_len)
{
  return offset >= src_len;
}

macro bool isNumStart(char c) => ascii::is_digit_m(c);
macro bool isDigit(char c) => ascii::is_digit_m(c);
macro bool isIdStart(char c) => ascii::is_alpha_m(c) || c == '_';
macro bool isIdPart(char c) => ascii::is_alpha_m(c) || c == '_' || isDigit(c);


