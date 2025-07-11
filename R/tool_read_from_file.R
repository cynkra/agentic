read_from_file <- function(path) {
  paste(readLines(path, warn = FALSE), collapse = "\n")
}

#' Tool: Read from File
#'
#' Returns a tool for reading the content of a flat file at the specified path.
#' @return A tool object
#' @export
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_read_from_file())
#'   tmp <- tempfile()
#'   writeLines("hello", tmp)
#'   chat$chat(paste("Read the file", tmp))
#' }
tool_read_from_file <- function() {
  tool(
    read_from_file,
    "Reads the content of a flat file at the specified path and returns it as a character string.",
    path = type_string(
      "The file path to read from.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Read from File",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 
