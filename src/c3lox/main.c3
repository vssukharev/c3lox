
module c3lox;
import std::io, c3lox::err;

/**
 * Entry point
 */
fn int main(String[] args)
{
  switch {
    case args.len == 1:
      if (catch err = run::prompt()) {
        io::eprintfn("%s occured while running a prompt", err);
      }
    
    case args.len == 2: 
      String* filename = &args[1];

      if (catch err = run::file(*filename)) {
        case IoError.FILE_NOT_FOUND:
          io::eprintfn("Could not find file %s", *filename);
        case ProgramError.USER_ERROR:
          return ExitCode.USER_ERROR.value;
        default:
          io::eprintfn("%s occured while running a file %s", err, *filename);
      }

    default: 
      io::eprintn("Usage: jlox [script]");
      return ExitCode.COMMAND_INPUT.value;
  }

	return ExitCode.OK.value;
}

