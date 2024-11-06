
module utils::logger;
import std::io;

/**
 * Prints user error stderr
 */
macro void userError(uint line, ...)
{
  io::eprintf("Error occured on line %s: ", line);
  $for (var $i = 0; $i < $vacount; ++$i)
    printArg($vaarg[$i]);
  $endfor
  io::eprint("\n");
}

/**
 * Prints arguments according to formatting
 */
macro void printArg(arg) @private
{
  $switch ($typeof(arg).typeid) 
    $case ichar.typeid:
    $case char.typeid:
      io::eprintf("%c", arg);
    $default:
      io::eprintf("%s", arg);
  $endswitch
}

