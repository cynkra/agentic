#' Set up agentic configuration and rules files from templates
#'
#' This function copies 'agentic-config.yaml' and 'agentic-rules.md' from the package's inst/ directory
#' to the specified directory (default: current working directory), overwriting any existing files.
#'
#' @param dir The directory in which to place the configuration and rules files. Defaults to the current working directory.
#' @return Returns `NULL` invisibly. Called for side effects.
#' @export
use_agentic <- function(ask = TRUE, dir = ".") {
  rules_template <- system.file("agentic-config.yaml", package = "agentic")
  if (ask) {
    config_template <- system.file("agentic-config.yaml", package = "agentic")
  } else {
    config_template <- system.file("agentic-config-yolo.yaml", package = "agentic")
  }
  file.copy(config_template, file.path(dir, "agentic-config.yaml"), overwrite = TRUE)
  file.copy(rules_template,  file.path(dir, "agentic-rules.md"),  overwrite = TRUE)
  invisible(TRUE)
}