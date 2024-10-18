
module c3lox::lexer;
import std::collections::list, std::io;

// lines.len == kinds.len == value_indices.len
struct Tokens (Printable) 
{
  TokenLineList lines;
  TokenKindList kinds;
  TokenValueIndices value_indices;
  TokenValueList values;
}

union TokenValue
{
  String str;
  int128 num_int;
  double num_float;
}

def TokenValueList = List(<TokenValue>);
def TokenValueIndices = List(<usz>);
def TokenLineList = List(<uint>);

/**
 * Scans for tokens
 *
 * @param src "Source code"
 */
fn void! Tokens.scan_all(&self, char[] src)
{
  bool is_end;
  while (!is_end) {
    self.scan_next();
  }
}

fn void Tokens.scan_next(&self)
{

}

/**
 * Initializes structure on heap
 *
 * @param val_cap "Values starting capacity"
 * @param comp_cap "Components starting capacity"
 *
 * @require val_cap > 0
 * @require comp_cap > 0
 */
fn void Tokens.new_init(&self, usz val_cap = 8, usz comp_cap = 16)
{
  self.values.new_init(val_cap);
  self.lines.new_init(capacity);
  self.kinds.new_init(capacity);
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

