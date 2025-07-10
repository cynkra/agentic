list_files <- function(path = ".") {
  list.files(path)
}

#' Tool: List files and directories
#'
#' Returns a tool object for listing files and directories in a given path.
#' @export
tool_list_files <- function() {
  tool(
    list_files,
    "Lists files and directories in the given path.",
    path = type_string("The path to list files in. Defaults to current directory.", required = FALSE),
    .annotations = tool_annotations(
      title = "List Files",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 