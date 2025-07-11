write_to_file <- function(path, content) {
  writeLines(content, con = path)
  invisible(path)
}

#' Tool: Write to File
#'
#' Returns a tool for writing a character string to a flat file at the specified path.
#' @return A tool object
#' @export
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_write_to_file())
#'   tmp <- tempfile()
#'   chat$chat(paste("Write 'hello' to the file", tmp))
#' }
tool_write_to_file <- function() {
  tool(
    write_to_file,
    "Writes a character string to a flat file at the specified path.",
    path = type_string(
      "The file path to write to.",
      required = TRUE
    ),
    content = type_string(
      "The content to write to the file.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Write to File",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = TRUE
    )
  )
} 