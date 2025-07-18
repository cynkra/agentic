#' Generate a GitHub Actions 'on:' specification for the 'issue_comment' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param types Character vector of issue_comment event types to trigger. See Details for choices. Default is c("created", "edited", "deleted").
#' @return A named list representing the YAML 'on:' block for the issue_comment event.
#' @details
#' Valid types for issue_comment are: "created", "edited", "deleted". The default is all three.
#' @examples
#' on_issue_comment()
#' on_issue_comment(types = c("created"))
#' @export
on_issue_comment <- function(types = c("created", "edited", "deleted")) {
  default_types <- c("created", "edited", "deleted")
  types <- match.arg(types, several.ok = TRUE)
  if (isTRUE(all.equal(types, default_types))) {
    return(list(issue_comment = "~"))
  }
  list(issue_comment = list(types = as.list(types)))
}