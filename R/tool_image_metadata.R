image_metadata <- function(path) {
  if (!requireNamespace("magick", quietly = TRUE)) {
    stop("The 'magick' package is required. Please install it with install.packages('magick').")
  }
  info <- magick::image_info(magick::image_read(path))
  list(
    width = info$width,
    height = info$height,
    format = info$format,
    colorspace = info$colorspace,
    filesize = info$filesize
  )
}

#' Tool: Image metadata
#'
#' Returns a tool object for getting image metadata (width, height, format, colorspace, filesize).
#' @export
tool_image_metadata <- function() {
  tool(
    image_metadata,
    "Returns image metadata (width, height, format, colorspace, filesize) for a given image file.",
    path = type_string("The path to the image file.", required = TRUE),
    .annotations = tool_annotations(
      title = "Image Metadata",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 
