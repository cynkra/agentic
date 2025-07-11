#' Create an agent with all agentic tools
#'
#' This function creates an agent using the specified model family (default: 'openai'),
#' registers all available agentic tools, and returns the agent object.
#'
#' @param provider The provider to use.
#' @param ... Additional arguments passed to the chat function for the provider.
#' @return An Chat object with all agentic tools registered.
#' @examples
#' ag <- agent()
#' ag$chat("What time is it?")
#' @export
agent <- function(..., provider = "openai") {
    chat_fun_nm <- paste0("chat_", provider)
    chat_fun <- getFromNamespace(chat_fun_nm, "ellmer")
    agentic_ns <- asNamespace("agentic")
    tools <- ls(agentic_ns, pattern = "^tool_")

    ag <- do.call(chat_fun, list(...), envir = globalenv())
    for (tool in tools) {
      ag$register_tool(agentic_ns[[tool]]())
    }
    ag
}
