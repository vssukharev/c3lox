
module c3lox;
import std::io;

/**
 * Entry point
 */
fn int main(String[] args)
{
  switch {
    case args.len == 1: 
    {
      if (catch err = runPrompt()) 
      {
        default:
          io::printfn("%s occured while running a prompt", err);
      }
    }
    
    case args.len == 2: 
    {
      String* filename = &args[1];

      if (catch err = runFile(*filename)) 
      {
        case IoError.FILE_NOT_FOUND:
          io::printfn("Could not find file %s", *filename);
        case ProgramError.USER_ERROR:
          return ExitCode.USER_ERROR.value;
        default:
          io::printfn("%s occured while running a file %s", err, *filename);
      }
    }

    default: 
    {
      io::printn("Usage: jlox [script]");
      return ExitCode.COMMAND_INPUT.value;
    }
  }

	return ExitCode.OK.value;
}

/**
 * Runs file as .lox script
 *
 *
 */
fn void! runFile(String filename) 
{ 
  char[] content = file::load_new(filename)!;
  defer free(content);
  run(content)!;
}


fn void! runPrompt() 
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

        if (catch err = run(line)) {
          case ProgramError.USER_ERROR: break;
          default: return err?;
        }
    }
  };
}

/**
 * @param [in] src
 *
 * @return! ProgramError.USER_ERROR
 */
fn void! run(char[] src) 
{
  Tokens tokens;
  tokens.new_init();
  defer tokens.free();

  lexer::scanTokens(&tokens, src)!;

  // foreach (&token : tokens) {
  //   io::printfn("%s", *token);
  // }
}


