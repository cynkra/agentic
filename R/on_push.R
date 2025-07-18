#' Generate a GitHub Actions 'on:' specification for the 'push' event
#'
#' Returns a list ready to be converted to a YAML block for the 'on:' section of a GitHub Actions workflow.
#'
#' @param branches Character vector of branch name patterns to include. Default is NULL (all branches).
#' @param branches_ignore Character vector of branch name patterns to exclude. Default is NULL.
#' @param tags Character vector of tag name patterns to include. Default is NULL.
#' @param tags_ignore Character vector of tag name patterns to exclude. Default is NULL.
#' @param paths Character vector of path patterns to include. Default is NULL.
#' @param paths_ignore Character vector of path patterns to exclude. Default is NULL.
#' @return A named list representing the YAML 'on:' block for the push event.
#' @examples
#' on_push()
#' on_push(branches = c("main"), paths = c("src/**"))
#' @export
on_push <- function(
  branches = NULL,
  branches_ignore = NULL,
  tags = NULL,
  tags_ignore = NULL,
  paths = NULL,
  paths_ignore = NULL
) {
  filters <- list(branches, branches_ignore, tags, tags_ignore, paths, paths_ignore)
  all_filters_default <- all(vapply(filters, is.null, logical(1)))
  if (all_filters_default) {
    return(list(push = "~"))
  }
  push <- list()
  if (!is.null(branches)) push$branches <- as.list(branches)
  if (!is.null(branches_ignore)) push$`branches-ignore` <- as.list(branches_ignore)
  if (!is.null(tags)) push$tags <- as.list(tags)
  if (!is.null(tags_ignore)) push$`tags-ignore` <- as.list(tags_ignore)
  if (!is.null(paths)) push$paths <- as.list(paths)
  if (!is.null(paths_ignore)) push$`paths-ignore` <- as.list(paths_ignore)
  list(push = push)
} 