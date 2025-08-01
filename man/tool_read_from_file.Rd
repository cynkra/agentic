% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tool_read_from_file.R
\name{tool_read_from_file}
\alias{tool_read_from_file}
\title{Tool: Read from File}
\usage{
tool_read_from_file()
}
\value{
A tool object
}
\description{
Returns a tool for reading the content of a flat file at the specified path.
}
\examples{
\dontrun{
  chat <- ellmer::chat_openai()
  chat$register_tool(tool_read_from_file())
  tmp <- tempfile()
  writeLines("hello", tmp)
  chat$chat(paste("Read the file", tmp))
}
}
