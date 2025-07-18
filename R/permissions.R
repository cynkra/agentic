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
#' Each permission can be 'none', 'read', or 'write'. Only permissions not set to 'none' will be included in the output.
#' @examples
#' permissions(contents = "read", issues = "write")
#' permissions() # default block (all permissions unset)
#' @export
permissions <- function(
  actions = "none",
  attestations = "none",
  checks = "none",
  contents = "none",
  deployments = "none",
  discussions = "none",
  id_token = "none",
  issues = "none",
  packages = "none",
  pages = "none",
  pull_requests = "none",
  repository_projects = "none",
  security_events = "none",
  statuses = "none"
) {
  permissions <- c(
    actions = match.arg(actions, c("none", "read", "write")),
    attestations = match.arg(attestations, c("none", "read", "write")),
    checks = match.arg(checks, c("none", "read", "write")),
    contents = match.arg(contents, c("none", "read", "write")),
    deployments = match.arg(deployments, c("none", "read", "write")),
    discussions = match.arg(discussions, c("none", "read", "write")),
    id_token = match.arg(id_token, c("none", "write")),
    issues = match.arg(issues, c("none", "read", "write")),
    packages = match.arg(packages, c("none", "read", "write")),
    pages = match.arg(pages, c("none", "read", "write")),
    pull_requests = match.arg(pull_requests, c("none", "read", "write")),
    repository_projects = match.arg(repository_projects, c("none", "read", "write")),
    security_events = match.arg(security_events, c("none", "read", "write")),
    statuses = match.arg(statuses, c("none", "read", "write"))
  )
  permissions <- permissions[permissions != "none"]
  list(permissions = as.list(permissions))
}
