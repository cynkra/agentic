#' Generate a GitHub Actions 'on:' specification for the 'release' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param types Character vector of release event types to trigger. See Details for choices. Default is c("published", "unpublished", "created", "edited", "deleted", "prereleased", "released").
#' @return A named list representing the YAML 'on:' block for the release event.
#' @details
#' Valid types for release are: "published", "unpublished", "created", "edited", "deleted", "prereleased", "released". The default is all seven.
#' @examples
#' on_release()
#' on_release(types = c("published", "created"))
#' @export
on_release <- function(types = c("published", "unpublished", "created", "edited", "deleted", "prereleased", "released")) {
  default_types <- c("published", "unpublished", "created", "edited", "deleted", "prereleased", "released")
  types <- match.arg(types, several.ok = TRUE)
  if (isTRUE(all.equal(types, default_types))) {
    return(list(release = "~"))
  }
  list(release = list(types = as.list(types)))
} 