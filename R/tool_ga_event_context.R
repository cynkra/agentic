#' Get value from GitHub Actions event context by path
#'
#' Parses the event JSON and returns the value at the given dot-separated path.
#' @param path Dot-separated path (e.g., "issue.body" or "pull_request.title").
#' @return The value at the specified path, or NULL if not found.
#' @export
ga_event_context <- function(path) {
  # in case the llm provides the full path rather than needed suffix
  path <- sub("^github\\.event\\.", "", path)
  ind <- strsplit(path, "\\.")[[1]]

  # a temporary local file created on the runner
  event_path <- Sys.getenv("GITHUB_EVENT_PATH")
  if (event_path == "") tool_reject("`GITHUB_EVENT_PATH` wasn't set, you need `GITHUB_EVENT_PATH: ${{ github.event_path }}`")
  if (!file.exists(event_path)) tool_reject("`GITHUB_EVENT_PATH` does not exist.")

  event <- jsonlite::fromJSON(event_path)
  event[[ind]]
}

#' Tool: GA Event Context
#'
#' Returns a tool object for retrieving a value from the github actions event payload.
#'
#' @return A tool object for use in agentic agents.
#' @examples
#' chat <- ellmer::chat_openai()
#' chat$register_tool(tool_ga_event_context())
#' chat$chat("What's the current issue's body?")
#' @export
tool_ga_event_context <- function() {
  tool(
    ga_event_context,
    "Returns the value from the GitHub Actions event payload for a given dot-separated path.",
    path = type_string("The dot-separated path (e.g., 'issue.body' or 'pull_request.title').", required = TRUE),
    .annotations = tool_annotations(
      title = "GA Event Context",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 