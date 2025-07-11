get_current_time <- function(tz = "UTC") {
  format(Sys.time(), tz = tz, usetz = TRUE)
}

#' Tool: Current time
#'
#' Returns a tool object for getting the current time in the given time zone.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_current_time())
#'   chat$chat("What is the current time?")
#' }
#' @export
tool_current_time <- function() {
  tool(
    get_current_time,
    "Gets the current time in the given time zone.",
    tz = type_string(
      "The time zone to get the current time in. Defaults to 'UTC'.",
      required = FALSE
    ),
    .annotations = tool_annotations(
      title = "Current Time",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = FALSE
    )
  )
} 