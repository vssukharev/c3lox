
module c3lox::lexer;
import std::io, std::collections::list;

struct TokenComponents (Printable)
{
  TokenLineList lines;
  TokenKindList kinds;
}

def TokenLine = uint;
def TokenLineList = List(<TokenLine>);

/**
 * Initializes TokenComponents on the heap
 *
 * @param capacity "Starting capacity for both self.lines and self.kinds"
 *
 * @require capacity > 0
 */
fn void TokenComponents.new_init(&self, usz capacity = 16)
{
  self.lines.new_init(capacity);
  self.kinds.new_init(capacity);
}

/**
 * Frees allocated memory
 */
fn void TokenComponents.free(&self)
{
  self.kinds.free();
  self.lines.free();
}

fn usz! TokenComponents.to_format(&self, Formatter* formatter) @dynamic
{
  return formatter.printf("%s, %s", self.lines, self.kinds)!;
}

