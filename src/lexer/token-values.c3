
module c3lox::lexer;
import std::collections::list;

struct TokenValues
{
  StringList strings;
  TokenIntegerList integers;
  TokenFloatList floats;
}

def TokenInteger = long @private;
def TokenFloat = double @private;

def StringList = List(<String>);
def TokenIntegerList = List(<TokenInteger>);
def TokenFloatList = List(<TokenFloat>);

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
  self.integers.new_init(capacity);
  self.floats.new_init(capacity);
}

/**
 * Frees allocated memory
 */
fn void TokenValues.free(&self)
{
  self.floats.free();
  self.integers.free();
  self.strings.free();
}

