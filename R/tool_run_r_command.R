
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
#' @export
tool_run_r_command <- function() {
  tool(
    run_r_command,
    "Runs an R command (expression) and returns its output as a string. Asks for confirmation before running.",
    expr = type_string(
      "The R command (expression) to run.",
      required = TRUE
    )
  )
}
