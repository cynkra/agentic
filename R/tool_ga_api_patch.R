ga_api_patch <- function(endpoint, body) {
  if (!length(body) || body == "") tool_reject("PATCH body must be a non-empty JSON string.")
  
  # Parse JSON string to R object
  body_obj <- tryCatch({
    jsonlite::fromJSON(body)
  }, error = function(e) {
    tool_reject(paste("Invalid JSON in body. You provided a regular text string, but this tool expects a valid JSON string. For updating an issue, use: '{\"title\": \"Updated title\", \"body\": \"Updated description\"}'. Error details:", e$message))
  })
  
  if (length(body_obj) == 0) tool_reject("PATCH body must contain non-empty content.")
  
  token <- Sys.getenv("GITHUB_TOKEN")
  if (token == "") tool_reject("GITHUB_TOKEN is not set in the environment.")
  base_url <- "https://api.github.com"
  url <- paste0(base_url, endpoint)
  default_headers <- c(
    Authorization = paste("Bearer", token),
    Accept = "application/vnd.github+json"
  )
  req <- httr::PATCH(url, httr::add_headers(.headers = default_headers), body = body_obj, encode = "json")
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

#' Tool: GitHub API PATCH
#'
#' Makes an authenticated PATCH call to the GitHub REST API using the GITHUB_TOKEN provided by the runner.
#' @export
tool_ga_api_patch <- function() {
  tool(
    ga_api_patch,
    "Makes an authenticated PATCH call to the GitHub REST API using the GITHUB_TOKEN provided by the runner.",
    endpoint = type_string(
      "The GitHub API endpoint (e.g., '/repos/owner/repo/issues/123' for updating an issue, '/repos/owner/repo/issues/comments/456' for updating a comment). :owner and :repo can be found in the event payload as `event.repository.owner.login` and `event.repository.name`",
      required = TRUE
    ),
    body = type_string(
      "A JSON string with proper structure. DO NOT pass plain text. For updating an issue, use: '{\"title\": \"Updated title\", \"body\": \"Updated description\"}'. For updating a comment, use: '{\"body\": \"Updated comment text\"}'.",
      required = TRUE
    ),
    .annotations = tool_annotations(
      title = "GitHub Actions API PATCH",
      read_only_hint = FALSE,
      open_world_hint = TRUE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
} 