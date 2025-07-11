escape_applescript <- function(x) {
  # x <- gsub('\\', '\\', x) # escape backslashes
  x <- gsub('"', '\\"', x)        # escape double quotes
  x <- gsub("\n", "\\n", x)      # escape newlines
  x
}

popup <- function(message, title = "Popup", type = "info", buttons = NULL) {
  sys <- Sys.info()[["sysname"]]
  if (sys == "Darwin") {
    # macOS: Use AppleScript
    message <- escape_applescript(message)
    title <- escape_applescript(title)
    btns <- if (!is.null(buttons)) paste0("buttons {", paste(sprintf('"%s"', buttons), collapse = ", "), "}") else ""
    type_str <- switch(type, info = "", warning = "with icon caution", error = "with icon stop", question = "with icon note", "")
    script <- sprintf('display dialog "%s" with title "%s" %s %s', message, title, btns, type_str)
    cmd <- sprintf('osascript -e %s', shQuote(script))
    res <- system(cmd, intern = TRUE)
    return(res)
  } else if (sys == "Linux") {
    # Linux: Use zenity (should be safe with shQuote)
    type_flag <- switch(type, info = "--info", warning = "--warning", error = "--error", question = "--question", "--info")
    btns_flag <- if (!is.null(buttons)) paste("--extra-button", paste(shQuote(buttons), collapse=" --extra-button ")) else ""
    cmd <- sprintf('zenity %s --text %s --title %s %s', type_flag, shQuote(message), shQuote(title), btns_flag)
    res <- system(cmd, intern = TRUE)
    return(res)
  } else if (sys == "Windows") {
    # Windows: Use msgbox via powershell (should be safe with sprintf)
    message <- gsub('"', '\\"', message)
    title <- gsub('"', '\\"', title)
    type_num <- switch(type, info = 0, warning = 48, error = 16, question = 32, 0)
    btns_num <- if (is.null(buttons)) 0 else 1 # 0=OK, 1=OK/Cancel
    script <- sprintf('[System.Windows.Forms.MessageBox]::Show("%s", "%s", %d, %d)', message, title, btns_num, type_num)
    cmd <- sprintf('powershell -Command %s', shQuote(script))
    res <- system(cmd, intern = TRUE)
    return(res)
  } else {
    stop("Unsupported OS for popup.")
  }
}


tool_popup <- function() {
  tool(
    popup,
    "Shows a popup message to the user.",
    message = type_string("The message to display in the popup.", required = TRUE),
    title = type_string("The title of the popup window.", required = FALSE),
    type = type_enum("The type of popup.", c("info", "warning", "error", "question"), required = FALSE),
    buttons = type_array("Button labels to show (optional)", items = type_string("A button label"), required = FALSE),
    .annotations = tool_annotations(
      title = "Popup",
      read_only_hint = TRUE,
      open_world_hint = FALSE,
      idempotent_hint = TRUE,
      destructive_hint = FALSE
    )
  )
}

#' Returns a tool object for showing a popup message to the user.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_popup())
#'   chat$chat("Show a popup saying 'Hello, world!'")
#' }
#' @export
