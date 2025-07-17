run_terminal_command <- function(command, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to run `%s`", command))
    if (!isTRUE(ans)) tool_reject()
  }
  output <- system(command, intern = TRUE)
  paste(output, collapse = "\n")
}

#' Tool: Run terminal command
#'
#' Returns a tool object for running a shell command in the system terminal and returning its output as a string.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_run_terminal_command())
#'   chat$chat("Run the command 'echo hello'")
#' }
#' @export
tool_run_terminal_command <- function(ask = TRUE) {
  run_terminal_command <- function(command) {
    agentic:::run_terminal_command(command, ask = ask)
  }
  tool(
    run_terminal_command,
    "Runs a shell command in the system terminal and returns its output as a string.",
    command = type_string(
      "The shell command to run.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Run Terminal Command",
      read_only_hint = FALSE,
      open_world_hint = TRUE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
}
