
module c3lox::lexer;
import c3lox::logger;

/**
 * Scans for tokens
 *
 * @param src "Source code"
 */
fn void scanTokens(Tokens* tokens, char[] src)
{
  uint lex_start; // lexeme start
  uint offset; // current offset
  uint line;      // current line

  while (!isEnd(offset, src.len)) {
    scanToken(tokens, &lex_start, &offset, &line, src);
  }

}

/**
 * @param [out] tokens
 * @param [inout] lexem_start "Start of lexem"
 * @param [inout] offset      "Current offset"
 * @param [inout] line        "Current line"
 * @param src                 "Source code"
 */
fn void scanToken(
  Tokens* tokens, 
  uint* lexem_start, 
  uint* offset, 
  uint* line, 
  char[] src)
{
  char c = src[*offset];
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
    default:
      logger::userError(*line, "Unexpected character: ", c);
  }

}

/**
 * @param offset  "Current offset"
 * @param src_len "Source code length"
 * @return "Whether we should stop our lexer"
 */
fn bool isEnd(uint offset, uint src_len)
{
  return offset >= src_len;
}

