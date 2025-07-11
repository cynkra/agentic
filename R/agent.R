#' Create an agent with all agentic tools
#'
#' This function creates an agent using the specified model family (default: 'openai'),
#' registers all available agentic tools, and returns the agent object.
#'
#' @param provider The provider to use.
#' @param system_prompt The system prompt. 
#'   If not provided and if a file named `agentic-rules.md` is found in the working directory
#'   its content will be used as the system prompt. 
#'   To force an empty system prompt over 'agentic-rules.md' use `system_prompt = ""`.
#' @param ... Additional arguments passed to the chat function for the provider.
#' @return An Chat object with all agentic tools registered.
#' @examples
#' ag <- agent()
#' ag$chat("What time is it?")
#' @export
agent <- function(system_prompt = NULL, ..., provider = "openai") {
    if (is.null(system_prompt) && file.exists("agentic-rules.md")) {
      system_prompt <- readLines("agentic-rules.md")
    }
    chat_fun_nm <- paste0("chat_", provider)
    chat_fun <- getFromNamespace(chat_fun_nm, "ellmer")
    agentic_ns <- asNamespace("agentic")
    tools <- ls(agentic_ns, pattern = "^tool_")

    ag <- chat_fun(system_prompt = system_prompt, ..., echo = "output")
    for (tool in tools) {
      ag$register_tool(agentic_ns[[tool]]())
    }
    ag
}
