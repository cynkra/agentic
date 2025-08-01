system_info <- function() {
  paste(capture.output(print(Sys.info())), collapse = "\n")
}

#' Tool: System info
#'
#' Returns a tool object for getting the system information as a string.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_system_info())
#'   chat$chat("Show the system info")
#' }
#' @export
tool_system_info <- function() {
  tool(
    system_info,
    "Returns the system information as a string.",
    .annotations = tool_annotations(
      title = "System Info",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 