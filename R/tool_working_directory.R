working_directory <- function() {
  getwd()
}

#' Tool: Working directory
#'
#' Returns a tool object for getting the current working directory.
#' @export
tool_working_directory <- function() {
  tool(
    working_directory,
    "Returns the current working directory."
  )
} 