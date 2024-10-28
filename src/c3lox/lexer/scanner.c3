
module c3lox::lexer;
import utils, std::io, std::ascii;

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

  uint offset    = 0; // current offset
  uint line      = 1; // current line

  while (!isEOF(offset, src.len)) {
    caught_error = @catch(scanToken(tokens, &offset, &line, src));
  }

  if (caught_error) return caught_error?;
}

/**
 * @param [out] tokens
 * @param [inout] offset      "Current offset"
 * @param [inout] line        "Current line"
 * @param src                 "Source code"
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! scanToken(
  Tokens* tokens, 
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

    case '!': tokens.push(*line, matchNextChar('=', offset, src)
              ? TokenKind.BANG_EQUAL : TokenKind.BANG);

    case '=': tokens.push(*line, matchNextChar('=', offset, src) 
              ? TokenKind.EQUAL_EQUAL : TokenKind.EQUAL);

    case '<': tokens.push(*line, matchNextChar('=', offset, src) 
              ? TokenKind.LESS_EQUAL : TokenKind.LESS);

    case '>': tokens.push(*line, matchNextChar('=', offset, src) 
              ? TokenKind.GREATER_EQUAL : TokenKind.GREATER);

    case '/': 
      switch (lookupNextChar(*offset, src)) {
        case '/': processLineComment(offset, src);
        case '*': processBlockComment(offset, src);
        default: tokens.push(*line, TokenKind.SLASH);
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
      if (isDigit(c)) {
        tokenizeNumericLiteral(tokens, offset, *line, src)!;
      } else if (isAlpha(c)) {
        tokenizeIdentifier(tokens, offset, *line, src);
      } else {
        logger::userError(*line, "Unexpected character: ", c);
        return ProgramError.USER_ERROR?;
      }
  }
}

/**
 * Modifies 'tokens' parameter by pushing 
 * identifier into it. 
 *
 * @param [&out] tokens "Tokens to be modified"
 * @param [&inout] offset "Offset of number start"
 * @param line "Current line"
 * @param src "Source code"
 *
 * @require isAlpha(src[*offset]) "First character of lexeme must be already found"
 */
fn void tokenizeIdentifier(
  Tokens* tokens,
  uint* offset,
  uint line,
  char[] src)
{
  uint lexeme_start = *offset;
  while(isAlphaNum(lookupNextChar(*offset, src))) ++*offset;

  String str_value = (String) src[lexeme_start..*offset];

  usz index = usz.max;
  foreach (usz i, TokenKind elem : KEYWORDS) {
    if (elem.str == str_value) index = i; break;
  }

  if (index != usz.max) {
    TokenKind kind = KEYWORDS[index];
    tokens.push(line, kind);
  } else {
    tokens.push_value(line, TokenKind.IDENTIFIER, str_value);
  } 
}

/**
 * Modifies 'tokens' parameter by pushing 
 * value of string literal into it. 
 * 
 * @param [&out] tokens "Tokens to be modified"
 * @param [&inout] offset "Offset of number start"
 * @param line "Current line"
 * @param src "Source code"
 *
 * @require isDigit(src[*offset]) "First character of lexeme must be already found"
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! tokenizeNumericLiteral(
  Tokens* tokens,
  uint* offset,
  uint line,
  char[] src)
{
  uint lexeme_start = *offset;
  
  while (isDigit(lookupNextChar(*offset, src))) ++*offset;
  
  char c = lookupNextChar(*offset, src); 

  if (isAlpha(c)) {
    // Consume alphabetical character
    ++*offset;
    uint suffix_start = *offset;
    while (isAlphaNum(lookupNextChar(*offset, src))) ++*offset;
    logger::userError(line, "Invalid suffix on numeric literal: ", src[suffix_start..*offset]);
    return ProgramError.USER_ERROR?;
  }

  // Look for fractional part
  if (c == '.' && 
      isDigit(lookupNextChar(*offset+1, src)))
  {
    // Consume the "."
    ++*offset;
    while (isDigit(lookupNextChar(*offset, src))) ++*offset;
  }

  String str_value = (String) src[lexeme_start..*offset];
  double value = str_value.to_double()!!; // panic here for now

  tokens.push_value(line, TokenKind.NUMBER, value);
}

/**
 * Modifies 'tokens' parameter by pushing 
 * value of string literal into it. 
 *
 * @param [&out] tokens "Tokens to be modified"
 * @param [&inout] line "Current line"
 * @param [&inout] offset "Offset of double quotes character"
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
 * Skips characters till block comment's 
 * end, by modifying 'offset'
 * 
 * @param [&inout] offset
 * @param src
 *
 * @require (src[*offset] == '/' && lookupNextChar(*offset, src) == '*') "Must be invoked when comment is detected ('offset' should be pointing to '/')"
 */ 
fn void processBlockComment(
  uint* offset,
  char[] src)
{
  uint nest_depth = 1; // quantity of nested comments
  char c;

  do {
    ++*offset;
    c = lookupNextChar(*offset, src);

    switch (c) {
      case '/':
        if (lookupNextChar(*offset+1, src) == '*') ++nest_depth;
      case '*':
        if (lookupNextChar(*offset+1, src) == '/') --nest_depth;
    }
  } while (nest_depth != 0 && c != Ascii.EOF.value);

  // feed last '*' and '/'
  *offset += 2;
}

/**
 * Skips characters till line comment's 
 * end, by modifying 'offset'
 * 
 * @param [&inout] offset
 * @param src
 *
 * @require (src[*offset] == '/' && lookupNextChar(*offset, src) == '/') "Must be invoked when comment is detected (offset should be pointing to first '/')"
 */
fn void processLineComment(
  uint* offset,
  char[] src)
{
  char c;

  do {
    ++*offset;
    c = lookupNextChar(*offset, src);
  } while (c != '\n' && c != Ascii.EOF.value);
}

/**
 * Safely look at the next char
 * and compares it with 'c'. If so,
 * set 'offset' to the position of the
 * next character.
 *
 * @param c "Character to compare with"
 * @param [&inout] offset "Current offset"
 * @param src "Source code"
 *
 * @return "true if characters are equal"
 */
fn bool matchNextChar(
  char c,
  uint* offset,
  char[] src)
{
  char next_c = lookupNextChar(*offset, src);
  if (next_c == c) { 
    ++*offset;
    return true;
  }

  return false;
}

/**
 * Safely look at the next char
 * and returns it
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

macro bool isDigit(char c) => ascii::is_digit_m(c);
macro bool isAlpha(char c) => ascii::is_alpha_m(c) || c == '_';
macro bool isAlphaNum(char c) => isAlpha(c) || isDigit(c);


