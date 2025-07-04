right_click <- function(x = NULL, y = NULL) {
  cmd <- "cliclick p:"
  position <- system(cmd, intern = TRUE)
  coords <- unlist(strsplit(position, ","))
  if (is.null(x)) x <- coords[[1]]
  if (is.null(y)) y <- coords[[2]]
  cmd <- sprintf("cliclick rc:%s,%s", x, y)
  system(cmd)
}

#' Tool: Right mouse click
#'
#' Returns a tool object for performing a right mouse click at the given (x, y) screen coordinates.
#' @export
tool_right_click <- function() {
  tool(
    right_click,
    "Performs a right mouse click at the given (x, y) screen coordinates. If x and y are not provided, clicks at the current mouse position.",
    x = type_integer(
      "The x coordinate for the click. If not provided, uses the current x position.",
      required = FALSE
    ),
    y = type_integer(
      "The y coordinate for the click. If not provided, uses the current y position.",
      required = FALSE
    )
  )
}