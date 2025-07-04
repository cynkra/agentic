session_info <- function() {
  paste(capture.output(sessionInfo()), collapse = "\n")
}

#' Tool: R session info
#'
#' Returns a tool object for getting the R session information as a string.
#' @export
tool_session_info <- function() {
  tool(
    session_info,
    "Returns the R session information as a string."
  )
} 