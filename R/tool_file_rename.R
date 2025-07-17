file_rename <- function(from, to, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to rename/move the file: %s to %s?", from, to))
    if (!isTRUE(ans)) tool_reject()
  }
  file.rename(from, to)
}

#' Tool: File Rename
#'
#' Renames or moves a file from one path to another. Returns TRUE if successful.
#' @param ask Boolean. If `TRUE` (default), ask for confirmation before renaming the file.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_file_rename())
#'   src <- tempfile()
#'   dest <- tempfile()
#'   writeLines("rename me", src)
#'   chat$chat(paste("Rename the file", src, "to", dest))
#' }
#' @export
tool_file_rename <- function(ask = TRUE) {
  file_rename <- function(from, to) {
    ns$file_rename(from, to, ask = ask)
  }
  tool(
    file_rename,
    "Renames or moves a file from one path to another. Returns TRUE if successful.",
    from = type_string("The current file path.", required = TRUE),
    to = type_string("The new file path.", required = TRUE),
    .annotations = tool_annotations(
      title = "File Rename",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = TRUE
    )
  )
} 