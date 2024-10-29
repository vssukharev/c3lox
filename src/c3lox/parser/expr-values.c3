
module c3lox::parser;
import c3lox::lexer;

struct ExprValues 
{
  BinaryExprList binary;
  GroupingExprList grouping;
  LiteralExprList literal;
  UnaryExprList unary;
}

def ExprValueKey = usz;

/**
 *
 */
macro ExprValues.get_expr(&self, $Type)
{

}

/**
 * Retruns a pointer to a field for 
 * specified underlying type. Result
 * has type List(<$Type>)
 *
 * @param $Type "Specified type. Must be either of types inside 'expr-kinds.cpp'"
 *
 * @return "List(<$Type>)"
 */
macro ExprValues.@field(&self, $Type) 
{
  $switch ($Type)
    $case BinaryExpr: 
      return &self.binary;
    $case GroupingExpr: 
      return &self.grouping;
    $case UnaryExpr: 
      return &self.unary;
    $case LiteralExpr: 
      return &self.literal;
    $default:
      $error "Attempt to access invalid field";
  $endswitch
}

/**
 * Initializes ExprValues on heap
 */
fn void ExprValues.new_init(&self, usz capacity = 16)
{
  self.binary.new_init(capacity);
  self.grouping.new_init(capacity);
  self.literal.new_init(capacity);
  self.unary.new_init(capacity);
}

/**
 * Frees ExprValues from heap
 */
fn void ExprValues.free(&self)
{
  self.binary.free();
  self.grouping.free();
  self.literal.free();
  self.unary.free();
}


