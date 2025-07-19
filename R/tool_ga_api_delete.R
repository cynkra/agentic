ga_api_delete <- function(endpoint) {
  token <- Sys.getenv("GITHUB_TOKEN")
  if (token == "") tool_reject("GITHUB_TOKEN is not set in the environment.")
  base_url <- "https://api.github.com"
  url <- paste0(base_url, endpoint)
  default_headers <- c(
    Authorization = paste("Bearer", token),
    Accept = "application/vnd.github+json"
  )
  req <- httr::DELETE(url, httr::add_headers(.headers = default_headers))
  status <- httr::status_code(req)
  result <- httr::content(req, as = "parsed", type = "application/json")
  if (!(status >= 200 && status < 300)) {
    tool_reject(sprintf("GitHub API call failed [%d]: %s", status, httr::content(req, as = "text")))
  }
  if (!is.null(result$content) && identical(result$encoding, "base64")) {
    result$content <- rawToChar(base64enc::base64decode(result$content))
  }
  return(result)
}

#' Tool: GitHub API DELETE
#'
#' Makes an authenticated DELETE call to the GitHub REST API using the GITHUB_TOKEN provided by the runner.
#' @export
tool_ga_api_delete <- function() {
  tool(
    ga_api_delete,
    "Makes an authenticated DELETE call to the GitHub REST API using the GITHUB_TOKEN provided by the runner.",
    endpoint = type_string(
      "The GitHub API endpoint (e.g., '/repos/:owner/:repo/issues/:issue_number/comments'). :owner and :repo can be found in the event payload as `event.repository.owner.login` and `event.repository.name`",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "GitHub Actions API DELETE",
      read_only_hint = FALSE,
      open_world_hint = TRUE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
} 