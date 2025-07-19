ga_api <- function(endpoint, method = "GET", body = NULL, headers = NULL) {
  if (!requireNamespace("httr", quietly = TRUE)) stop("Please install the 'httr' package.")
  token <- Sys.getenv("GITHUB_TOKEN")
  if (token == "") stop("GITHUB_TOKEN is not set in the environment.")
  base_url <- "https://api.github.com"
  url <- paste0(base_url, endpoint)
  default_headers <- c(
    Authorization = paste("Bearer", token),
    Accept = "application/vnd.github+json"
  )
  if (!is.null(headers)) {
    all_headers <- c(default_headers, headers)
  } else {
    all_headers <- default_headers
  }
  req <- switch(
    toupper(method),
    GET = httr::GET(url, httr::add_headers(.headers = all_headers)),
    POST = httr::POST(url, httr::add_headers(.headers = all_headers), body = body, encode = "json"),
    PATCH = httr::PATCH(url, httr::add_headers(.headers = all_headers), body = body, encode = "json"),
    PUT = httr::PUT(url, httr::add_headers(.headers = all_headers), body = body, encode = "json"),
    DELETE = httr::DELETE(url, httr::add_headers(.headers = all_headers)),
    stop("Unsupported HTTP method: ", method)
  )
  status <- httr::status_code(req)
  if (status >= 200 && status < 300) {
    return(httr::content(req, as = "parsed", type = "application/json"))
  } else {
    stop(sprintf("GitHub API call failed [%d]: %s", status, httr::content(req, as = "text")))
  }
}

#' Tool: GA API (GitHub Actions API)
#'
#' Returns a tool object for making authenticated GitHub REST API calls using the GITHUB_TOKEN provided by the runner.
#'
#' @return A tool object for use in agentic agents.
#' @examples
#' chat <- ellmer::chat_openai()
#' chat$register_tool(tool_ga_api())
#' chat$chat("Call the GitHub API endpoint /repos/owner/repo/issues/1/comments with method POST and body {body: 'Hello!'}")
#' @export
tool_ga_api <- function() {
  tool(
    ga_api,
    "Makes an authenticated call to the GitHub REST API using the GITHUB_TOKEN provided by the runner.",
    endpoint = type_string(
      "The GitHub API endpoint (e.g., '/repos/:owner/:repo/issues/:issue_number/comments'). :owner and :repo can be found in the event payload as `event.repository.owner.login` and `event.repository.name`",
      required = TRUE
    ),
    method = type_enum(
      "The HTTP method to use.",
      c("GET", "POST", "PATCH", "PUT", "DELETE"),
      required = TRUE
    ),
    body = type_object(
      "Optional list to send as JSON body (for POST/PATCH/PUT).",
      .required = FALSE
    ),
    headers = type_object(
      "Optional named list of additional headers.",
      .required = FALSE
    ),
    .annotations = tool_annotations(
      title = "GitHub Actions API",
      read_only_hint = FALSE,
      open_world_hint = TRUE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
}

