
module c3lox::lexer;
import std::collections::list;

def TokenNumber = double;
def TokenString = String;

def TokenStringList = List(<TokenString>);
def TokenNumberList = List(<TokenNumber>);

struct TokenValues
{
  TokenStringList strings;
  TokenNumberList numbers;
}

struct TokenValueKey
{
  usz index;
  TokenKind kind;
}

/**
 * Allocates TokenValues on the heap
 *
 * @param capacity
 *
 * @require capacity > 0
 */
fn void TokenValues.new_init(&self, usz capacity = 16)
{
  self.strings.new_init(capacity);
  self.numbers.new_init(capacity);
}

/**
 * Frees allocated memory
 */
fn void TokenValues.free(&self)
{
  self.numbers.free();
  self.strings.free();
}

