% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tool_file_rename.R
\name{tool_file_rename}
\alias{tool_file_rename}
\title{Tool: File Rename}
\usage{
tool_file_rename(ask = TRUE)
}
\arguments{
\item{ask}{Boolean. If \code{TRUE} (default), ask for confirmation before renaming the file.}
}
\description{
Renames or moves a file from one path to another. Returns TRUE if successful.
}
\examples{
\dontrun{
  chat <- ellmer::chat_openai()
  chat$register_tool(tool_file_rename())
  src <- tempfile()
  dest <- tempfile()
  writeLines("rename me", src)
  chat$chat(paste("Rename the file", src, "to", dest))
}
}
