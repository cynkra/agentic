file_copy <- function(from, to) {
  file.copy(from, to)
}

#' Tool: File copy
#'
#' Returns a tool object for copying a file from one path to another.
#' @export
tool_file_copy <- function() {
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