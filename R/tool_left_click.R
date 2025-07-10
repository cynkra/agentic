left_click <- function(x = NULL, y = NULL) {
  cmd <- "cliclick p:"
  position <- system(cmd, intern = TRUE)
  coords <- unlist(strsplit(position, ","))
  if (is.null(x)) x <- coords[[1]]
  if (is.null(y)) y <- coords[[2]]
  cmd <- sprintf("cliclick c:%s,%s", x, y)
  system(cmd)
}

#' Tool: Left mouse click
#'
#' Returns a tool object for performing a left mouse click at the given (x, y) screen coordinates.
#' @export
tool_left_click <- function() {
  tool(
    left_click,
    "Performs a left mouse click at the given (x, y) screen coordinates. If x and y are not provided, clicks at the current mouse position.",
    x = type_integer(
      "The x coordinate for the click. If not provided, uses the current x position.",
      required = FALSE
    ),
    y = type_integer(
      "The y coordinate for the click. If not provided, uses the current y position.",
      required = FALSE
    ),
    .annotations = tool_annotations(
      title = "Left Mouse Click",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
}
