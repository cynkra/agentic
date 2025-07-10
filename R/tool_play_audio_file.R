play_audio_file <- function(file) {
  sys <- Sys.info()[["sysname"]]
  if (!file.exists(file)) stop("File does not exist: ", file)
  
  if (sys == "Darwin") {
    # macOS: Prefer afplay, then ffplay, then fallback
    if (nzchar(Sys.which("afplay"))) {
      system2("afplay", shQuote(file))
    } else if (nzchar(Sys.which("ffplay"))) {
      system2("ffplay", c("-autoexit", "-nodisp", shQuote(file)), stdout = FALSE, stderr = FALSE)
    } else {
      warning("No blocking audio player found (afplay/ffplay). Using 'open', which may not wait for playback to finish.")
      system2("open", shQuote(file), wait = FALSE)
    }
  } else if (sys == "Linux") {
    # Linux: Try mpg123, mpv, ffplay, then fallback
    if (nzchar(Sys.which("mpg123"))) {
      system2("mpg123", shQuote(file))
    } else if (nzchar(Sys.which("mpv"))) {
      system2("mpv", c("--no-video", shQuote(file)), stdout = FALSE, stderr = FALSE)
    } else if (nzchar(Sys.which("ffplay"))) {
      system2("ffplay", c("-autoexit", "-nodisp", shQuote(file)), stdout = FALSE, stderr = FALSE)
    } else {
      warning("No blocking audio player found (mpg123/mpv/ffplay). Using 'xdg-open', which may not wait for playback to finish.")
      system2("xdg-open", shQuote(file), wait = FALSE)
    }
  } else if (sys == "Windows") {
    # Windows: Use PowerShell to play audio and block
    ext <- tolower(tools::file_ext(file))
    if (ext == "wav") {
      # Use SoundPlayer for wav files
      ps <- sprintf('Add-Type -AssemblyName presentationCore; $player = New-Object system.media.soundplayer "%s"; $player.PlaySync();', normalizePath(file, winslash = "/", mustWork = TRUE))
      shell(sprintf('powershell -Command "%s"', ps), wait = TRUE)
    } else {
      # Try Windows Media Player COM for mp3, etc.
      ps <- sprintf('$player = New-Object -ComObject WMPlayer.OCX; $media = $player.newMedia("%s"); $player.controls.play(); while ($player.playState -ne 1) { Start-Sleep -Milliseconds 200 }', normalizePath(file, winslash = "/", mustWork = TRUE))
      shell(sprintf('powershell -Command "%s"', ps), wait = TRUE)
    }
  } else {
    stop("Unsupported OS for audio playback.")
  }
  invisible(TRUE)
}

#' Tool: Play Audio File
#'
#' Opens and plays an audio file (e.g., mp3) using a command-line player and waits for playback to finish. Falls back to the system's default player if needed (may not block).
#' @param file The path to the audio file to play.
#' @return TRUE (invisible)
#' @export
tool_play_audio_file <- function() {
  tool(
    play_audio_file,
    "Opens and plays an audio file (e.g., mp3) using a command-line player and waits for playback to finish. Falls back to the system's default player if needed (may not block).",
    file = type_string("The path to the audio file to play.", required = TRUE),
    .annotations = tool_annotations(
      title = "Play Audio File",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 
