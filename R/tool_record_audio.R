record_audio <- function(file = tempfile(fileext=".wav")) {
  if (!requireNamespace("processx", quietly = TRUE)) stop("Please install the 'processx' package.")

  message("Recording... Press ENTER to stop.")

  # Start SoX recording in the background
  rec_proc <- processx::process$new(
    command = "sox",
    args = c("-d", file),
    stdout = "|",
    stderr = "|"
  )

  # Wait for Enter
  invisible(readline())

  message("Stopping recording...")

  # Kill the SoX process
  rec_proc$kill()
  rec_proc$wait()  # Ensure it finishes cleanup

  message("Recording saved to: ", normalizePath(file, mustWork = FALSE))
  invisible(file)
}

#' Tool: Record Audio
#'
#' Records audio from the system microphone and saves it to a file.
#' @param output_file The path to save the recorded audio file (e.g., .wav or .mp3).
#' @param duration The duration of the recording in seconds.
#' @return The path to the saved audio file.
#' @export
tool_record_audio <- function() {
  tool(
    record_audio,
    "Records audio from the system microphone and returns the path to the recording in a .wav file.",
    .annotations = tool_annotations(
      title = "Record Audio",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = FALSE
    )
  )
}
