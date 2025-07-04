wait <- function(t) {
    for(i in seq(t)) {
        Sys.sleep(1)
        # for debugging purposes we print a dot each sec
        cat(".")
    }
}

#' Tool: Wait
#'
#' Returns a tool object for waiting a specified number of seconds.
#' @export
tool_wait <- function() {
  tool(
    wait,
    "Waits for some time",
    t = type_integer(
      "Number of seconds to wait",
      required = TRUE
    )
  )
}