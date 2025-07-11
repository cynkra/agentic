screenshot <- function(file = tempfile(fileext = ".png")) {
  cmd <- sprintf("screencapture -xC %s", shQuote(file))
  system(cmd)
  invisible(file)
}

#' Tool: Screenshot
#'
#' Returns a tool object for taking a screenshot and returning the path to the PNG file.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_screenshot())
#'   chat$chat("Take a screenshot")
#' }
#' @export
tool_screenshot <- function() {
  tool(
    screenshot,
    "Takes a screenshot if the system allows and returns the path to the png file of the screenshot. Can be used when we need context about which app is open for instance.",
    .annotations = tool_annotations(
      title = "Screenshot",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = FALSE
    )
  )
}