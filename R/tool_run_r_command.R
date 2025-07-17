
run_r_command <- function(expr, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to run the R command: %s", expr))
    if (!isTRUE(ans)) stop("Interrupted by user")
  }
  output <- capture.output(eval(parse(text = expr), envir = .GlobalEnv))
  paste(output, collapse = "\n")
}

#' Tool: Run R command
#'
#' Returns a tool object for running an R command (expression) and returning its output as a string.
#' @param ask Boolean. If `TRUE` (default), ask for confirmation before running the R command.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_run_r_command())
#'   chat$chat("Run the R command '1 + 1'")
#' }
#' @export
tool_run_r_command <- function(ask = TRUE) {
  run_r_command <- function(expr) {
    agentic:::run_r_command(expr, ask = ask)
  }
  tool(
    run_r_command,
    "Runs an R command (expression) and returns its output as a string. Asks for confirmation before running.",
    expr = type_string(
      "The R command (expression) to run.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Run R Command",
      read_only_hint = FALSE,
      open_world_hint = TRUE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
}
