module c3lox;
import std::io;


struct C3Lox 
{
  bool aha;
}

/**
 * Entry point
 */
fn int main(String[] args)
{
  switch {
    case args.len == 1: 
    {
      if (catch err = runPrompt()) {
        case ProgramError.USER_ERROR:
          return ExitCode.USER_ERROR.value;
        default:
          io::printfn("%s occured while running a prompt", err);
      }
    }
    
    case args.len == 2: 
    {
      if (catch err = runFile(args[0])) {
        case IoError.FILE_NOT_FOUND:
          io::printfn("Could not find file %s", args[0]);
        case ProgramError.USER_ERROR:
          return ExitCode.USER_ERROR.value;
        default:
          io::printfn("%s occured while running a file %s", err, args[0]);
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
  run(content)!;
}


fn void! runPrompt() 
{
  @pool() {
    while(true) {
      io::print("c3lox > ");
      
        String! line = io::treadline();

        if (catch err = line) {
          if (err == IoError.EOF) return;
          return err?;
        }

        if (line == ":q") return;

        run(line)!;
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
  TokenList tokens;
  tokens.new_init();

  lexer::scanTokens(&tokens)!;
 
  foreach (&token : tokens) {
    io::printfn("%s", *token);
  }
}


