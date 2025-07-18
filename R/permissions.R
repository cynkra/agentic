#' Generate a GitHub Actions 'permissions' block
#'
#' Returns a list ready to be converted to a YAML block for the 'permissions' section of a GitHub Actions workflow.
#'
#' @param actions Controls access to workflow run and job management. 'read': view workflow runs/jobs; 'write': cancel or approve runs/jobs.
#' @param attestations Controls access to artifact attestations. 'read': view attestations; 'write': generate attestations for builds.
#' @param checks Controls access to check runs and check suites. 'read': view checks; 'write': create or update checks.
#' @param contents Controls access to repository contents (code, files, branches, releases, tags). 'read': view contents; 'write': push code, create releases, etc.
#' @param deployments Controls access to deployments. 'read': view deployments; 'write': create or update deployments.
#' @param discussions Controls access to GitHub Discussions. 'read': view discussions; 'write': create, edit, or delete discussions.
#' @param id_token Controls access to OpenID Connect tokens. Only 'write' is allowed: request OIDC tokens for cloud authentication.
#' @param issues Controls access to issues. 'read': view issues; 'write': create, edit, comment, or close issues.
#' @param packages Controls access to GitHub Packages. 'read': download/use packages; 'write': publish or delete packages.
#' @param pages Controls access to GitHub Pages. 'read': view pages; 'write': request builds or update pages.
#' @param pull_requests Controls access to pull requests. 'read': view PRs; 'write': create, edit, comment, or merge PRs.
#' @param repository_projects Controls access to repository projects. 'read': view projects; 'write': create or update projects.
#' @param security_events Controls access to code scanning and Dependabot alerts. 'read': view alerts; 'write': update or dismiss alerts.
#' @param statuses Controls access to commit statuses. 'read': view statuses; 'write': set commit statuses.
#' @return A named list representing the YAML 'permissions' block.
#' @details
#' Valid values for each permission are 'read', 'write', or NULL. Some permissions only support a subset (see GitHub docs). Defaults are NULL, which means the permission is not set and both read and write are disallowed unless explicitly set. You may specify both 'read' and 'write' for permissions that support both.
#' @examples
#' permissions(contents = c("read", "write"), issues = "write")
#' permissions() # default block (all permissions unset)
#' @export
permissions <- function(
  actions = NULL,
  attestations = NULL,
  checks = NULL,
  contents = NULL,
  deployments = NULL,
  discussions = NULL,
  id_token = NULL,
  issues = NULL,
  packages = NULL,
  pages = NULL,
  pull_requests = NULL,
  repository_projects = NULL,
  security_events = NULL,
  statuses = NULL
) {
  out <- list()
  validate <- function(val, allowed, nm) {
    if (is.null(val)) {
      return(NULL)
    }
    if (all(val %in% allowed)) {
      return(as.list(unique(val)))
    }
    stop(sprintf("`%s` must be 'read', 'write', a vector with both, or NULL", nm))
  }
  out[["actions"]] <- validate(actions, c("read", "write"), "actions")
  out[["attestations"]] <- validate(attestations, c("read", "write"), "attestations")
  out[["checks"]] <- validate(checks, c("read", "write"), "checks")
  out[["contents"]] <- validate(contents, c("read", "write"), "contents")
  out[["deployments"]] <- validate(deployments, c("read", "write"), "deployments")
  out[["discussions"]] <- validate(discussions, c("read", "write"), "discussions")
  out[["id-token"]] <- validate(id_token, c("write"), "id_token")
  out[["issues"]] <- validate(issues, c("read", "write"), "issues")
  out[["packages"]] <- validate(packages, c("read", "write"), "packages")
  out[["pages"]] <- validate(pages, c("read", "write"), "pages")
  out[["pull-requests"]] <- validate(pull_requests, c("read", "write"), "pull_requests")
  out[["repository-projects"]] <- validate(repository_projects, c("read", "write"), "repository_projects")
  out[["security-events"]] <- validate(security_events, c("read", "write"), "security_events")
  out[["statuses"]] <- validate(statuses, c("read", "write"), "statuses")
  # Remove NULLs
  out <- out[!vapply(out, is.null, logical(1))]
  if (length(out) == 0) return(list(permissions = "~"))
  list(permissions = out)
} 
