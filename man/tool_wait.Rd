% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tool_wait.R
\name{tool_wait}
\alias{tool_wait}
\title{Tool: Wait}
\usage{
tool_wait()
}
\description{
Returns a tool object for waiting a specified number of seconds.
}
\examples{
\dontrun{
  chat <- ellmer::chat_openai()
  chat$register_tool(tool_wait())
  chat$chat("Wait for 2 seconds")
}
}
