
module c3lox::parser;
import c3lox::lexer;

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseExpr(
  Exprs* exprs, 
  Tokens* tokens,
  TokenKey* offset) 
{
  return parseEquality(exprs, tokens, offset);
}

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseEquality(
  Exprs* exprs, 
  Tokens* tokens,
  TokenKey* offset)
{
  ExprKey left_expr = parseComparison(exprs, tokens, offset);

  TokenKind kind = lookupNextTokenKind(&tokens.kinds, *offset);
  while (kind == BANG_EQUAL 
      || kind == EQUAL_EQUAL) 
  {
    ++*offset;
    ExprKey right_expr = parseComparison(exprs, tokens, offset);
    left_expr = exprs.push(BinaryExpr{left_expr, right_expr, kind});
  }

  return left_expr;
}

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseComparison(
  Exprs* exprs,
  Tokens* tokens,
  TokenKey* offset)
{
  ExprKey left_expr = parseTerm(exprs, tokens, offset);

  TokenKind kind = lookupNextTokenKind(&tokens.kinds, *offset);
  while (kind == GREATER 
      || kind == GREATER_EQUAL
      || kind == LESS
      || kind == LESS_EQUAL) 
  {
    ++*offset;
    ExprKey right_expr = parseTerm(exprs, tokens, offset);
    left_expr = exprs.push(BinaryExpr{left_expr, right_expr, kind});
  }

  return left_expr;
}

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseTerm(
  Exprs* exprs,
  Tokens* tokens,
  TokenKey* offset)
{
  ExprKey left_expr = parseFactor(exprs, tokens, offset);

  TokenKind kind = lookupNextTokenKind(&tokens.kinds, *offset);
  while (kind == MINUS 
      || kind == PLUS) 
  {
    ++*offset;
    ExprKey right_expr = parseFactor(exprs, tokens, offset);
    left_expr = exprs.push(BinaryExpr{left_expr, right_expr, kind});
  }

  return left_expr;
}

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseFactor(
  Exprs* exprs,
  Tokens* tokens,
  TokenKey* offset)
{
  ExprKey left_expr = parseUnary(exprs, tokens, offset);

  TokenKind kind = lookupNextTokenKind(&tokens.kinds, *offset);
  if (kind == SLASH 
   || kind == STAR) 
  {
    ++*offset;
    ExprKey right_expr = parseUnary(exprs, tokens, offset);
    return exprs.push(BinaryExpr{left_expr, right_expr, kind});
  }

  return left_expr;
}

/**
 * @param [&inout] exprs "Expressions to be modified"
 * @param [&in] tokens "Tokens, retrieved from lexer"
 * @param [&inout] offset
 */
fn ExprKey parseUnary(
  Exprs* exprs,
  Tokens* tokens,
  TokenKey* offset)
{
  TokenKind kind = lookupNextTokenKind(&tokens.kinds, *offset);
  if (kind == BANG 
   || kind == MINUS) 
  {
    ++*offset;
    ExprKey right_expr = parseUnary(exprs, tokens, offset);
    return exprs.push(UnaryExpr{right_expr, kind});
  }

  return parsePrimary(exprs, tokens, offset);
}
/**
 * Lookups next token kind without 
 * modifying offset
 *
 * @param [&in] token_kinds
 * @param offset
 */
fn TokenKind lookupNextTokenKind(
  TokenKindList* token_kinds,
  TokenKey offset)
{
  ++offset;
  if (offset >= token_kinds.len()) return TokenKind.EOF;
  return (*token_kinds)[offset];
}

