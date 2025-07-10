
browse_url <- function(url, browser) {
  # on Mac
  substr(browser, 1, 1) <- toupper(substr(browser, 1, 1))
  browser <- switch(
    browser,
    "Chrome" = "Google Chrome",
    "Edge" = "Microsoft Edge",
    "Brave" = "Brave Browser",
    browser
  )
  browser <- sprintf("open -a '%s'", browser)
  browseURL(url, browser)
}

#' Tool: Browse URL
#'
#' Returns a tool object for getting the current content of the system clipboard as a string.
#' @export
tool_browse_url <- function() {
  tool(
    browse_url,
    "Browse to the given URL",
    url = type_string("A valid URL"),
    browser = typestring("Name of the browser to use"),
    .annotations = tool_annotations(
      title = "Browse URL",
      read_only_hint = TRUE,
      open_world_hint = TRUE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
}