% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tool_run_r_command.R
\name{tool_run_r_command}
\alias{tool_run_r_command}
\title{Tool: Run R command}
\usage{
tool_run_r_command(ask = TRUE)
}
\arguments{
\item{ask}{Boolean. If \code{TRUE} (default), ask for confirmation before running the R command.}
}
\description{
Returns a tool object for running an R command (expression) and returning its output as a string.
}
\examples{
\dontrun{
  chat <- ellmer::chat_openai()
  chat$register_tool(tool_run_r_command())
  chat$chat("Run the R command '1 + 1'")
}
}
