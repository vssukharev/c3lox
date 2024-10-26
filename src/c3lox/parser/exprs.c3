
module c3lox::parser;
import std::collections::list, c3lox::lexer;

struct Exprs {
  ExprNodeList nodes;
  ExprValues values;
}

// Index to access a particular expression
def ExprIndex = usz;

def ExprNodeList = List(<ExprNode>);
struct ExprNode {
  typeid type;
  usz value_i;
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
 *
 */
macro void Exprs.push(&self, val)
{
  usz i = 0;

  $switch ($typeof(val).typeid)
    $case BinaryExpr.typeid:
      self.values.binary.push(val);  
      i = self.values.binary.len() - 1;
    $case GroupingExpr.typeid:
      self.values.grouping.push(val);  
      i = self.values.grouping.len() - 1;
    $case UnaryExpr.typeid:
      self.values.unary.push(val);  
      i = self.values.unary.len() - 1;
    $case LiteralExpr.typeid:
      self.values.literal.push(val);  
      i = self.values.literal.len() - 1;
    $default:
      $error "Attempt to push value of invalid type in Exprs";
  $endswitch

  self.nodes.push({ $typeof(val).typeid, i });
}

