wait <- function(t) {
    for(i in seq(t)) {
        Sys.sleep(1)
        # for debugging purposes we print a dot each sec
        cat(".")
    }
}

#' Tool: Wait
#'
#' Returns a tool object for waiting a specified number of seconds.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_wait())
#'   chat$chat("Wait for 2 seconds")
#' }
#' @export
tool_wait <- function() {
  tool(
    wait,
    "Waits for some time",
    t = type_integer(
      "Number of seconds to wait",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "Wait",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = FALSE
    )
  )
}