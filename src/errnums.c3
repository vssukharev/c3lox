
module c3lox::err;

enum ExitCode : int (int value) {
  OK = 0,
  COMMAND_INPUT = 1,
  USER_ERROR = 2,
}

fault ProgramError {
  USER_ERROR
}


