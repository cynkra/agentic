copy_to_clipboard <- function(text) {
  if (!requireNamespace("clipr", quietly = TRUE)) {
    stop("The 'clipr' package is required. Please install it with install.packages('clipr').")
  }
  clipr::write_clip(text)
  invisible(TRUE)
}

#' Tool: Copy to clipboard
#'
#' Returns a tool object for copying text to the system clipboard.
#' @export
tool_copy_to_clipboard <- function() {
  tool(
    copy_to_clipboard,
    "Copies the given text to the system clipboard.",
    text = type_string(
      "The text to copy to the clipboard.",
      required = TRUE
    )
  )
}
