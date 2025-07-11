text_input <- function(prompt = "Please enter text:") {
  readline(prompt)
}

#' Tool: Text Input
#'
#' Prompts the user for text input and returns it as a string.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_text_input())
#'   chat$chat("Ask the user for their name")
#' }
#' @return The text entered by the user.
#' @export
tool_text_input <- function() {
  tool(
    text_input,
    "Prompts the user for text input and returns it as a string.",
    prompt = type_string("The prompt to display to the user.", required = FALSE),
    .annotations = tool_annotations(
      title = "Text Input",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = FALSE
    )
  )
} 