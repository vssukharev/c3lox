
module c3lox::lexer;
import std::collections::list, std::io;

// lines.len == kinds.len == value_indices.len
struct Tokens (Printable) 
{
  TokenLineList lines;
  TokenKindList kinds;
  TokenValueIndices value_indices;
  TokenValues values;
}

def TokenValueIndices = List(<usz>);
def TokenLineList = List(<uint>);

/**
 * Pushes the token information without value.
 * value_indices are pushed with usz.max
 *
 * @param line
 * @param kind
 */
fn void Tokens.push(&self, uint line, TokenKind kind)
{
  self.lines.push(line);
  self.kinds.push(kind);
  self.value_indices.push(usz.max);
}

/**
 * Automatically detects type of val and pushes it to self.values
 *
 * @param val
 * @param line
 * @param kind
 */
macro void Tokens.push_value(&self, uint line, TokenKind kind, val)
{
  usz i;

  $switch ($typeof(val).typeid)
    $case TokenInteger.typeid:
      i = self.values.integers.push_unique(val);
    $case TokenFloat.typeid:
      i = self.values.floats.push_unique(val);
    $case String.typeid:
      i = self.values.strings.push_unique(val);
    $default:
      $error "Attempt to push value of invalid type";
  $endswitch

  self.lines.push(line);
  self.kinds.push(kind);
  self.value_indices.push(i);
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

fn usz! Tokens.to_format(&self, Formatter* formatter) @dynamic
{
  return formatter.printf("%s, %s", self.lines, self.kinds)!;
}


