run_terminal_command <- function(command, ask = TRUE) {
  # if (ask) {
  #   ans <- askYesNo(sprintf("Do you agree to run `%s`", command))
  #   if (!isTRUE(ans)) stop("Interrupted by used")
  # }
  output <- system(command, intern = TRUE)
  paste(output, collapse = "\n")
}

#' Tool: Run terminal command
#'
#' Returns a tool object for running a shell command in the system terminal and returning its output as a string.
#' @export
tool_run_terminal_command <- function() {
  tool(
    run_terminal_command,
    "Runs a shell command in the system terminal and returns its output as a string.",
    command = type_string(
      "The shell command to run.",
      required = TRUE
    )
  )
}
