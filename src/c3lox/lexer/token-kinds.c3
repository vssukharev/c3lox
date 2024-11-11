
module c3lox::lexer;
import std::collections::list;

const TokenKind[] KEYWORDS = @genKeywords();

def TokenKindList = List(<TokenKind>);
enum TokenKind : int (String str) {
  // Single-character tokens.
  LEFT_PAREN  = "(", 
  RIGHT_PAREN = ")", 
  LEFT_BRACE  = "{", 
  RIGHT_BRACE = "}",
  COMMA       = ",", 
  DOT         = ".", 
  MINUS       = "-", 
  PLUS        = "+", 
  SEMICOLON   = ";", 
  SLASH       = "/", 
  STAR        = "*",

  // One or two character tokens.
  BANG          = "!", 
  BANG_EQUAL    = "!=",
  EQUAL         = "=", 
  EQUAL_EQUAL   = "==",
  GREATER       = ">", 
  GREATER_EQUAL = ">=",
  LESS          = "<", 
  LESS_EQUAL    = "<=",

  // Literals.
  IDENTIFIER = "<IDENTIFIER_LIT>", 
  STRING     = "<STRING_LIT>", 
  NUMBER     = "<NUMBER_LIT>",

  // Keywords. MUST begin with AND and end befor EOF
  AND     = "and", 
  CLASS   = "class", 
  ELSE    = "else", 
  FALSE   = "false", 
  FUN     = "fun", 
  FOR     = "for", 
  IF      = "if", 
  NIL     = "nil", 
  OR      = "or",
  PRINT   = "print", 
  RETURN  = "return", 
  SUPER   = "super", 
  THIS    = "this", 
  TRUE    = "true",
  VAR     = "var", 
  WHILE   = "while",

  EOF = "<EOF>"
}

/**
 * Generates array of TokenKind, containing all keywords.
 * All keywords must be located in range [AND; EOF),
 * where AND and EOF are enum members respectively.
 */
macro TokenKind[] @genKeywords() 
{
  int $first;
  int $last;
  $for (var $i = 0; $i != TokenKind.values.len; ++$i)
    $switch(TokenKind.values[$i])
      $case TokenKind.AND:
        $first = $i;
      $case TokenKind.EOF:
        $last = $i-1;
    $endswitch
  $endfor

  return TokenKind.values[$first..$last];
}

