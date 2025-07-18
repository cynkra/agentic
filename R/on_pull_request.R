#' Generate a GitHub Actions 'on:' specification for the 'pull_request' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param types Character vector of pull request event types to trigger. See Details for choices. Default is c("opened", "synchronize", "reopened").
#' @param branches Character vector of branch name patterns to include. Default is NULL (all branches).
#' @param branches_ignore Character vector of branch name patterns to exclude. Default is NULL.
#' @param tags Character vector of tag name patterns to include. Default is NULL.
#' @param tags_ignore Character vector of tag name patterns to exclude. Default is NULL.
#' @param paths Character vector of path patterns to include. Default is NULL.
#' @param paths_ignore Character vector of path patterns to exclude. Default is NULL.
#' @return A named list representing the YAML 'on:' block for the pull_request event.
#' @details
#' Valid types for pull_request are:
#'   "assigned", "auto_merge_enabled", "auto_merge_disabled", "closed", "converted_to_draft",
#'   "demilestoned", "dequeued", "edited", "enqueued", "labeled", "locked", "milestoned",
#'   "opened", "ready_for_review", "reopened", "review_request_removed", "review_requested",
#'   "synchronize", "unassigned", "unlabeled", "unlocked"
#' The default is c("opened", "synchronize", "reopened").
#' @examples
#' on_pull_request()
#' on_pull_request(types = c("opened", "edited"), branches = c("main"))
#' @export
on_pull_request <- function(
  types = c("opened", "synchronize", "reopened"),
  branches = NULL,
  branches_ignore = NULL,
  tags = NULL,
  tags_ignore = NULL,
  paths = NULL,
  paths_ignore = NULL
) {
  all_types <- c(
    "assigned", "auto_merge_enabled", "auto_merge_disabled", "closed", "converted_to_draft",
    "demilestoned", "dequeued", "edited", "enqueued", "labeled", "locked", "milestoned",
    "opened", "ready_for_review", "reopened", "review_request_removed", "review_requested",
    "synchronize", "unassigned", "unlabeled", "unlocked"
  )
  types <- match.arg(types, choices = all_types, several.ok = TRUE)
  default_types <- c("opened", "synchronize", "reopened")
  # Check if all filters are at default
  filters <- list(branches, branches_ignore, tags, tags_ignore, paths, paths_ignore)
  all_filters_default <- all(vapply(filters, is.null, logical(1)))
  types_is_default <- isTRUE(all.equal(types, default_types))
  if (types_is_default && all_filters_default) {
    return(list(pull_request = "~"))
  }
  pr <- list()
  if (!types_is_default) pr$types <- as.list(types)
  if (!is.null(branches)) pr$branches <- as.list(branches)
  if (!is.null(branches_ignore)) pr$`branches-ignore` <- as.list(branches_ignore)
  if (!is.null(tags)) pr$tags <- as.list(tags)
  if (!is.null(tags_ignore)) pr$`tags-ignore` <- as.list(tags_ignore)
  if (!is.null(paths)) pr$paths <- as.list(paths)
  if (!is.null(paths_ignore)) pr$`paths-ignore` <- as.list(paths_ignore)
  list(pull_request = pr)
} 