
module c3lox::parser;
import std::collections::list, c3lox::lexer, std::io;

struct Exprs {
  ExprNodeList nodes;
  ExprValues values;
}

// Index to access a particular expression
def ExprKey = usz;

def ExprNodeList = List(<ExprNode>);
struct ExprNode {
  typeid type;
  usz index;
}

/**
 * Initializes Exprs on heap
 */
fn void Exprs.new_init(&self, usz capacity = 16) 
{
  self.nodes.new_init(capacity);
  self.values.new_init(capacity);
}

/**
 * Frees Exprs from heap
 */
fn void Exprs.free(&self)
{
  self.nodes.free();
  self.values.free();
}

/**
 *
 */
macro ExprKey Exprs.push(&self, val)
{
  var $Type = $typeof(val);
  var field = self.values.@field($Type);

  field.push(val);

  self.nodes.push({$Type.typeid, field.len()-1});
  // io::eprintfn("Pushing %s with value %s", $Type.nameof, val);

  return self.nodes.len()-1;
}

