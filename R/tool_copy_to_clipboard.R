copy_to_clipboard <- function(text) {
  if (!requireNamespace("clipr", quietly = TRUE)) {
    tool_reject("The 'clipr' package is required but not installed. Please install it with install.packages('clipr').")
  }
  clipr::write_clip(text)
  invisible(TRUE)
}

#' Tool: Copy to clipboard
#'
#' Returns a tool object for copying text to the system clipboard.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_copy_to_clipboard())
#'   chat$chat("Copy 'hello world' to the clipboard")
#' }
#' @export
tool_copy_to_clipboard <- function() {
  tool(
    copy_to_clipboard,
    "Copies the given text to the system clipboard.",
    text = type_string(
      "The text to copy to the clipboard.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Copy to Clipboard",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = TRUE
    )
  )
}
