#' Generate a GitHub Actions 'on:' specification for the 'pull_request_review_comment' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param types Character vector of pull_request_review_comment event types to trigger. See Details for choices. Default is c("created", "edited", "deleted").
#' @return A named list representing the YAML 'on:' block for the pull_request_review_comment event.
#' @details
#' Valid types for pull_request_review_comment are: "created", "edited", "deleted". The default is all three.
#' @examples
#' on_pull_request_review_comment()
#' on_pull_request_review_comment(types = c("created"))
#' @export
on_pull_request_review_comment <- function(types = c("created", "edited", "deleted")) {
  default_types <- c("created", "edited", "deleted")
  types <- match.arg(types, several.ok = TRUE)
  if (isTRUE(all.equal(types, default_types))) {
    return(list(pull_request_review_comment = "~"))
  }
  list(pull_request_review_comment = list(types = as.list(types)))
} 