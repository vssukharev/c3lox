
module c3lox::lexer;
import std::io, c3lox::err, utils::alias;

// lines.len == kinds.len == value_indices.len
def TokenKey = usz;
struct Tokens
{
  UlongList lines;
  TokenKindList kinds;
  UszList value_indices;
  TokenValues values;
}

macro TokenKey Tokens.len(&self) => self.lines.len();

/**
 * Returns value under specified TokenKey
 *
 * @param i "Index"
 *
 * @return! LexerError.NO_VAL_UNDER_INDEX
 */
fn TokenValueKey! Tokens.get_value_key(&self, TokenKey i)
{
  TokenKind kind = self.kinds[i];
  TokenValueKey res; 

  switch (kind) {
    case TokenKind.STRING:
    case TokenKind.NUMBER:
    case TokenKind.IDENTIFIER:
      res = { self.value_indices[i], kind };
    default:
      return LexerError.NO_VAL_UNDER_INDEX?;
  }

  return res;
}

/**
 * Pushes the token information without value.
 * value_indices are pushed with usz.max
 *
 * @param line
 * @param kind
 */
fn TokenKey Tokens.push(&self, uint line, TokenKind kind)
{
  self.lines.push(line);
  self.kinds.push(kind);
  // io::eprintfn("Pushing TokenKind %s on line %s", kind, line);
  self.value_indices.push(usz.max);

  return self.value_indices.len()-1;
}

/**
 * Automatically detects type of val and pushes it to self.values
 *
 * @param val
 * @param line
 * @param kind
 */
macro TokenKey Tokens.push_value(&self, uint line, TokenKind kind, val)
{
  usz i;

  $switch ($typeof(val))
    $case TokenNumber:
      i = self.values.numbers.push_unique(val);
    $case TokenString:
      i = self.values.strings.push_unique(val);
    $default:
      $error "Attempt to push value of invalid type";
  $endswitch

  self.lines.push(line);
  // io::eprintfn("Pushing TokenKind %s on line %s with value %s", kind, line, val);
  self.kinds.push(kind);
  self.value_indices.push(i);
  
  return self.value_indices.len()-1;
}

/**
 * Initializes structure on heap
 *
 * @param values_cap "Values starting capacity"
 * @param components_cap "Starting capacity for self.lines and self.kinds"
 *
 * @require values_cap > 0
 * @require components_cap > 0
 */
fn void Tokens.new_init(&self, usz values_cap = 8, usz components_cap = 16)
{
  self.values.new_init(values_cap);
  self.lines.new_init(components_cap);
  self.kinds.new_init(components_cap);
}

/**
 * Frees allocated memory
 */
fn void Tokens.free(&self)
{
  self.kinds.free();
  self.lines.free();
  self.values.free();
}


