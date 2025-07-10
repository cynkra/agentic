cursor_position <- function(x = NULL, y = NULL) {
  cmd <- "cliclick p:"
  position <- system(cmd, intern = TRUE)
  coords <- unlist(strsplit(position, ","))
  list(x = as.integer(coords[1]), y = as.integer(coords[2]))
}

#' Tool: Mouse cursor position
#'
#' Returns a tool object for getting the current mouse cursor position.
#' @export
tool_cursor_position <- function() {
  tool(
    cursor_position,
    "Gets the current mouse cursor position.",
    .annotations = tool_annotations(
      title = "Cursor Position",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
}