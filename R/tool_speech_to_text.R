speech_to_text <- function(file, model = "whisper-1") {
  if (!requireNamespace("httr", quietly = TRUE)) stop("Please install the 'httr' package.")
  api_key <- Sys.getenv("OPENAI_API_KEY")
  if (api_key == "") stop("Please set your OpenAI API key in the OPENAI_API_KEY environment variable.")
  if (!file.exists(file)) stop("File does not exist: ", file)

  url <- "https://api.openai.com/v1/audio/transcriptions"
  resp <- httr::POST(
    url,
    httr::add_headers(Authorization = paste("Bearer", api_key)),
    body = list(
      file = httr::upload_file(file),
      model = model
    ),
    encode = "multipart"
  )
  if (httr::status_code(resp) != 200) {
    stop("OpenAI Whisper API request failed: ", httr::content(resp, as = "text"))
  }
  result <- httr::content(resp, as = "parsed", type = "application/json")
  result$text
}

#' Tool: Speech to Text (OpenAI Whisper API)
#'
#' Converts speech in an audio file to text using OpenAI's Whisper API.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_speech_to_text())
#'   chat$chat("Transcribe the audio file 'path/to/audio.wav'")
#' }
#' @param file The complete absolute path to the audio file to transcribe.
#' @param model The Whisper model to use (default: 'whisper-1').
#' @return The transcribed text.
#' @export
tool_speech_to_text <- function() {
  tool(
    speech_to_text,
    "Converts speech in an audio file to text using OpenAI's Whisper API.",
    file = type_string("The path to the audio file to transcribe.", required = TRUE),
    model = type_string("The Whisper model to use (default: 'whisper-1').", required = FALSE),
    .annotations = tool_annotations(
      title = "Speech to Text",
      read_only_hint = TRUE,
      open_world_hint = TRUE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
} 