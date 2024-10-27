
module c3lox::lexer;
import std::io, utils::err, utils::alias;

// lines.len == kinds.len == value_indices.len
def TokenKey = usz;
struct Tokens
{
  UlongList lines;
  TokenKindList kinds;
  UszList value_indices;
  TokenValues values;
}

// Basic getters for conveniance
macro ulong Tokens.get_line(&self, TokenKey i) => self.lines[i];
macro TokenKind Tokens.get_kind(&self, TokenKey i) => self.kinds[i];
macro TokenString Tokens.get_string_value(&self, usz i) => self.values.strings[i];
macro TokenNumber Tokens.get_number_value(&self, usz i) => self.values.numbers[i];
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
  TokenValueKey res = { 0, kind }; 

  switch (kind) {
    case TokenKind.STRING:
    case TokenKind.NUMBER:
      res.index = self.value_indices[i];
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

  return self.lines.len()-1;
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

  $switch ($typeof(val).typeid)
    $case TokenNumber.typeid:
      i = self.values.numbers.push_unique(val);
    $case TokenString.typeid:
      i = self.values.strings.push_unique(val);
    $default:
      $error "Attempt to push value of invalid type";
  $endswitch

  self.lines.push(line);
  // io::eprintfn("Pushing TokenKind %s on line %s with value %s", kind, line, val);
  self.kinds.push(kind);
  self.value_indices.push(i);
  
  return i;
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


