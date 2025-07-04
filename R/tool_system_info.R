system_info <- function() {
  paste(capture.output(print(Sys.info())), collapse = "\n")
}

#' Tool: System info
#'
#' Returns a tool object for getting the system information as a string.
#' @export
tool_system_info <- function() {
  tool(
    system_info,
    "Returns the system information as a string."
  )
} 