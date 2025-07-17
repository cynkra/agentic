
file_delete <- function(path, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to delete the file: %s?", path))
    if (!isTRUE(ans)) tool_reject()
  }
  file.remove(path)
}

#' Tool: Delete a file
#'
#' Returns a tool object for deleting a specified file.
#' @param ask Boolean. If `TRUE` (default), ask for confirmation before deleting the file.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_file_delete())
#'   tmp <- tempfile()
#'   writeLines("delete me", tmp)
#'   chat$chat(paste("Delete the file", tmp))
#' }
#' @export
tool_file_delete <- function(ask = TRUE) {
  file_delete <- function(path) {
    agentic:::file_delete(path, ask = ask)
  }
  tool(
    file_delete,
    "Deletes the specified file. Returns TRUE if successful.",
    path = type_string("The file path to delete.", required = TRUE),
    .annotations = tool_annotations(
      title = "File Delete",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = TRUE
    )
  )
} 