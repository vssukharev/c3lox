
module c3lox::lexer;
import std::collections::list, std::io;

struct Tokens (Printable) 
{
  inline TokenComponents comps;
  TokenValueList values;
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
  self.comps.new_init(comp_cap) @inline;
}

/**
 * Frees allocated memory
 */
fn void Tokens.free(&self)
{
  self.comps.free() @inline;
  self.values.free();
}

fn usz! Tokens.to_format(&self, Formatter* formatter) @dynamic
{
  return formatter.printf("%s", self.comps)!;
}

