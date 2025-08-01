% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tool_multiple_choices.R
\name{tool_multiple_choices}
\alias{tool_multiple_choices}
\title{Tool: Multiple choice input}
\usage{
tool_multiple_choices()
}
\description{
Returns a tool object for presenting a multiple choice question to the user.
}
\examples{
\dontrun{
  chat <- ellmer::chat_openai()
  chat$register_tool(tool_multiple_choices())
  chat$chat("Ask me to choose between apple, banana, and cherry")
}
}
