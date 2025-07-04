multiple_choices <- function(question, choices) {
  i <- utils::menu(choices, title = question)
  choices[[i]]
}

#' Tool: Multiple choice input
#'
#' Returns a tool object for presenting a multiple choice question to the user.
#' @export
tool_multiple_choices <- function() {
  tool(
    multiple_choices,
    "Gives a multiple choice input to the user and returns the choice",
    question = type_string("the question to ask to the user"),
    choices = type_array(
      "possible choices",
      items = type_string("A choice")
    )
  )
}

