
module c3lox::run;
import std::io, utils::err, c3lox::lexer;

/**
 * @param [in] src
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! interpreter(char[] src) 
{
  Tokens tokens;
  tokens.new_init();
  defer tokens.free();

  lexer::scanTokens(&tokens, src)!;

  tokens.print();
}

/**
 * Runs file as .lox script
 *
 *
 */
fn void! file(String filename) 
{ 
  char[] content = file::load_new(filename)!;
  defer free(content);
  interpreter(content)!;
}

/**
 *
 */
fn void! prompt() 
{
  @pool() {
    while(true) {
      io::print("c3lox > ");
      
        char[]! line = io::treadline();

        if (catch err = line) {
          if (err == IoError.EOF) return;
          return err?;
        }

        if (line == ":q") return;

        if (catch err = interpreter(line)) {
          case ProgramError.USER_ERROR: break;
          default: return err?;
        }
    }
  };
}

