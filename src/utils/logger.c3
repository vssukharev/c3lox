
module utils::logger;
import std::io;

/**
 * Prints user error stderr
 */
macro void userError(uint line, ...)
{
  io::printf("Error occured on line %s: ", line);
  $for (var $i = 0; $i < $vacount; ++$i)
    printArg($vaarg[$i]);
  $endfor
  io::printn();
}

/**
 * Prints arguments according to formatting
 */
macro void printArg(arg) @private
{
  $switch ($typeof(arg).typeid) 
    $case ichar.typeid:
    $case char.typeid:
      io::printf("%c", arg);
    $default:
      io::printf("%s", arg);
  $endswitch
}

