working_directory <- function() {
  getwd()
}

#' Tool: Working directory
#'
#' Returns a tool object for getting the current working directory.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_working_directory())
#'   chat$chat("What is the current working directory?")
#' }
#' @export
tool_working_directory <- function() {
  tool(
    working_directory,
    "Returns the current working directory.",
    .annotations = tool_annotations(
      title = "Working Directory",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 