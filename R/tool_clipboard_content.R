clipboard_content <- function() {
  if (!requireNamespace("clipr", quietly = TRUE)) {
    stop("The 'clipr' package is required. Please install it with install.packages('clipr').")
  }
  clipr::read_clip() |> paste(collapse = "\n")
}

#' Tool: Clipboard content
#'
#' Returns a tool object for getting the current content of the system clipboard as a string.
#' @export
tool_clipboard_content <- function() {
  tool(
    clipboard_content,
    "Gets the current content of the system clipboard as a string.",
    .annotations = tool_annotations(
      title = "Clipboard Content",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
}
