
file_delete <- function(path) {
  file.remove(path)
}

#' Tool: Delete a file
#'
#' Returns a tool object for deleting a specified file.
#' @export
tool_file_delete <- function() {
  tool(
    file_delete,
    "Deletes the specified file. Returns TRUE if successful.",
    path = type_string("The file path to delete.", required = TRUE)
  )
} 