
module c3lox::lexer;

const String[] KEYWORDS_STRINGS = {
  "and",
  "class",
  "else",
  "false",
  "for",
  "fun",
  "if",
  "nil",
  "or",
  "print",
  "return",
  "super",
  "this",
  "true",
  "var",
  "while",
};

const TokenKind[] KEYWORDS_KINDS = {
  AND,
  CLASS,
  ELSE,
  FALSE,
  FOR,
  FUN,
  IF,
  NIL,
  OR,
  PRINT,
  RETURN,
  SUPER,
  THIS,
  TRUE,
  VAR,
  WHILE,
};

