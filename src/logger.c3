
module c3lex::logger;
import std::io;

macro void error(uint line, String message) 
{
  report(line, "", message);
}

fn void report(int line, String where, String message)
{
  io::printfn("[Line %s] Error%s: %s", line, where, message);
}

