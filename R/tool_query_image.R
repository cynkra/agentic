query_image <- function(query, img_path) {
  chat <- ellmer::chat_openai(model = "gpt-4o")
  # LLMs don't know what time is it
  chat$chat(
    query,
    ellmer::content_image_file(img_path)
  )
  answer <- capture.output(chat$last_turn())
  answer
}

#' Tool: Query image
#'
#' Returns a tool object for answering a query in the context of an image.
#' @export
tool_query_image <- function() {
  tool(
    query_image,
    "Answers a query in the context of an image",
    query = type_string(
      "A query about the image",
      required = TRUE
    ),
    img_path = type_string(
      "The path of the image use to answer the query",
      required = TRUE
    )
  )
}
