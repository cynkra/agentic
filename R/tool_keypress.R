keypress <- function(key, control = FALSE, command = FALSE, shift = FALSE, option = FALSE, fn = FALSE, ask = TRUE) {
  if (ask) {
    ans <- askYesNo(sprintf("Do you agree to simulate keypress: %s?", key))
    if (!isTRUE(ans)) tool_reject()
  }
  key_map <- c(
    "F1" = 122, "F2" = 120, "F3" = 99, "F4" = 118, "F5" = 96, "F6" = 97,
    "F7" = 98, "F8" = 100, "F9" = 101, "F10" = 109, "F11" = 103, "F12" = 111,
    "esc" = 53, "enter" = 36, "return" = 36, "delete" = 51, "backspace" = 51,
    "space" = 49, "tab" = 48, "left" = 123, "right" = 124, "down" = 125, "up" = 126,
    "home" = 115, "end" = 119, "page_down" = 121, "page_up" = 116
  )
  modifiers <- c()
  if (control) modifiers <- c(modifiers, "control down")
  if (command) modifiers <- c(modifiers, "command down")
  if (shift)   modifiers <- c(modifiers, "shift down")
  if (option)  modifiers <- c(modifiers, "option down")
  if (fn)      modifiers <- c(modifiers, "fn down")
  if (nchar(key) == 1) {
    # Single character: use keystroke
    if (length(modifiers) > 0) {
      cmd <- sprintf(
        'osascript -e \'tell application "System Events" to keystroke "%s" using {%s}\'',
        key,
        paste(modifiers, collapse = ", ")
      )
    } else {
      cmd <- sprintf(
        'osascript -e \'tell application "System Events" to keystroke "%s"\'',
        key
      )
    }
  } else {
    # Special key: use key code
    keycode <- key_map[[tolower(key)]]
    if (is.null(keycode)) stop("Unknown key: ", key)
    if (length(modifiers) > 0) {
      cmd <- sprintf(
        'osascript -e \'tell application "System Events" to key code %s using {%s}\'',
        keycode,
        paste(modifiers, collapse = ", ")
      )
    } else {
      cmd <- sprintf(
        'osascript -e \'tell application "System Events" to key code %s\'',
        keycode
      )
    }
  }
  system(cmd)
  invisible(TRUE)
}

#' Tool: Keypress
#'
#' Returns a tool object for simulating a keypress (with optional modifiers).
#' @param ask Boolean. If `TRUE` (default), ask for confirmation before simulating the keypress.
#' @examples
#' \dontrun{
#'   chat <- ellmer::chat_openai()
#'   chat$register_tool(tool_keypress())
#'   chat$chat("Press the Enter key")
#' }
#' @export
tool_keypress <- function(ask = TRUE) {
  keypress <- function(key, control = FALSE, command = FALSE, shift = FALSE, option = FALSE, fn = FALSE) {
    ns$keypress(key, control, command, shift, option, fn, ask = ask)
  }
  tool(
    keypress,
    "Simulates a keypress (with optional modifiers). Make sure we know which system is used and which app is active so we can avoid for example using a Windows hotkey on Mac, or a standard hotkey for an app that does things differently.",
    key = type_string("The key to press (e.g. 's', 'F1', 'left', etc.)", required = TRUE),
    control = type_boolean("Whether to hold the Control key", required = FALSE),
    command = type_boolean("Whether to hold the Command key", required = FALSE),
    shift = type_boolean("Whether to hold the Shift key", required = FALSE),
    option = type_boolean("Whether to hold the Option/Alt key", required = FALSE),
    fn = type_boolean("Whether to hold the Fn key", required = FALSE),
    .annotations = tool_annotations(
      title = "Keypress",
      read_only_hint = FALSE,
      open_world_hint = FALSE,
      idempotent_hint = FALSE,
      destructive_hint = TRUE
    )
  )
}
