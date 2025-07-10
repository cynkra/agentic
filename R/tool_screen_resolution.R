screen_resolution <- function() {
  sys <- Sys.info()[["sysname"]]
  if (sys == "Darwin") {
    res <- system("/usr/sbin/system_profiler SPDisplaysDataType | grep Resolution", intern = TRUE)
    dims <- as.integer(unlist(regmatches(res, gregexpr("\\d+", res))))
    width <- dims[1]
    height <- dims[2]
  } else if (sys == "Linux") {
    res <- system("xdpyinfo | grep dimensions", intern = TRUE)
    dims <- as.integer(unlist(regmatches(res, gregexpr("\\d+", res))))
    width <- dims[1]
    height <- dims[2]
  } else if (sys == "Windows") {
    width <- as.integer(system("wmic path Win32_VideoController get CurrentHorizontalResolution", intern = TRUE)[2])
    height <- as.integer(system("wmic path Win32_VideoController get CurrentVerticalResolution", intern = TRUE)[2])
  } else {
    stop("Unsupported OS for screen resolution.")
  }
  list(width = width, height = height)
}

#' Tool: Screen resolution
#'
#' Returns a tool object for getting the screen resolution (width and height in pixels).
#' @export
tool_screen_resolution <- function() {
  tool(
    screen_resolution,
    "Returns the screen resolution as a list with width and height in pixels.",
    .annotations = tool_annotations(
      title = "Screen Resolution",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 
