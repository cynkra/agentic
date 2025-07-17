file_copy <- function(from, to, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to copy the file: %s to %s?", from, to))
    if (!isTRUE(ans)) tool_reject()
  }
  file.copy(from, to)
}

#' Tool: File copy
#'
#' Returns a tool object for copying a file from one path to another.
#' @param ask Boolean. If `TRUE` (default), ask for confirmation before copying the file.
#' @export
tool_file_copy <- function(ask = TRUE) {
  file_copy <- function(from, to) {
    ns$file_copy(from, to, ask = ask)
  }
  tool(
    file_copy,
    "Copies a file from one path to another. Returns TRUE if successful.",
    from = type_string("The source file path.", required = TRUE),
    to = type_string("The destination file path.", required = TRUE),
    .annotations = tool_annotations(
      title = "File Copy",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = TRUE
    )
  )
}

#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_file_copy())
#'   src <- tempfile()
#'   dest <- tempfile()
#'   writeLines("hello", src)
#'   chat$chat(paste("Copy the file from", src, "to", dest))
#' } 