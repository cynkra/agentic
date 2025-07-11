  text_to_speech <- function(text, voice = "alloy", output_file = tempfile(fileext = ".mp3")) {
    if (!requireNamespace("httr", quietly = TRUE)) stop("Please install the 'httr' package.")
    if (!requireNamespace("jsonlite", quietly = TRUE)) stop("Please install the 'jsonlite' package.")
    api_key <- Sys.getenv("OPENAI_API_KEY")
    if (api_key == "") stop("Please set your OpenAI API key in the OPENAI_API_KEY environment variable.")
    url <- "https://api.openai.com/v1/audio/speech"
    body <- list(
      model = "tts-1",
      input = text,
      voice = voice,
      response_format = "mp3"
    )
    resp <- httr::POST(
      url,
      httr::add_headers(Authorization = paste("Bearer", api_key)),
      httr::content_type_json(),
      body = jsonlite::toJSON(body, auto_unbox = TRUE),
      encode = "raw"
    )
    if (httr::status_code(resp) != 200) {
      stop("OpenAI TTS API request failed: ", httr::content(resp, as = "text"))
    }
    bin <- httr::content(resp, as = "raw")
    writeBin(bin, output_file)
    return(output_file)
  }

#' Tool: Text to Speech (OpenAI Whisper API)
#'
#' Converts text to speech using OpenAI's TTS API (tts-1).
#' @return The path to the saved audio file.
#' @export
tool_text_to_speech <- function() {
  tool(
    text_to_speech,
    "Converts text to speech using OpenAI's TTS API (tts-1).",
    text = type_string("The text to convert to speech.", required = TRUE),
    voice = type_enum("The voice to use.", c("alloy", "echo", "fable", "onyx", "nova", "shimmer"), required = FALSE),
    .annotations = tool_annotations(
      title = "Text to Speech",
      read_only_hint = TRUE,
      open_world_hint = TRUE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
}