#' Generate a GitHub Actions 'on:' specification for the 'issues' event
#'
#' Returns a list ready to be converted to a YAML block to use in the 'on:' block in a GitHub Actions workflow
#'
#' @param types Character vector of issue event types to trigger.
#' @return A named list representing the YAML 'on:' block for the issues event.
#' @examples
#' on_issues()
#' on_issues(types = c('opened', 'edited'))
#' @export
on_issues <- function(types = c(
    "opened", "edited", "deleted", "transferred", "pinned", "unpinned",
    "closed", "reopened", "assigned", "unassigned", "labeled", "unlabeled",
    "locked", "unlocked", "milestoned", "demilestoned")) {
  # validate inputs
  types <- match.arg(types, several.ok = TRUE)
  # simplify if the default is provided
  default <- c(
    "opened", "edited", "deleted", "transferred", "pinned", "unpinned",
    "closed", "reopened", "assigned", "unassigned", "labeled", "unlabeled",
    "locked", "unlocked", "milestoned", "demilestoned"
  )
  if (isTRUE(all.equal(types, default))) {
    return(list(issues =  "~"))
  }
  # return a list ready to convert to yaml
  list(issues = list(types = as.list(types)))
}
