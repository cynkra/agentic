#' Generate a GitHub Actions 'on:' specification for the 'pull_request_review' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param types Character vector of pull_request_review event types to trigger. See Details for choices. Default is c("submitted", "edited", "dismissed").
#' @return A named list representing the YAML 'on:' block for the pull_request_review event.
#' @details
#' Valid types for pull_request_review are: "submitted", "edited", "dismissed". The default is all three.
#' @examples
#' on_pull_request_review()
#' on_pull_request_review(types = c("submitted"))
#' @export
on_pull_request_review <- function(types = c("submitted", "edited", "dismissed")) {
  default_types <- c("submitted", "edited", "dismissed")
  types <- match.arg(types, several.ok = TRUE)
  if (isTRUE(all.equal(types, default_types))) {
    return(list(pull_request_review = "~"))
  }
  list(pull_request_review = list(types = as.list(types)))
} 