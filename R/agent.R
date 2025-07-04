agent <- function(model_family = "openai", ...) {
    chat_fun_nm <- paste0("chat_", model_family)
    chat_fun <- getFromNamespace(chat_fun_nm, "ellmer")
    ag <- chat_fun(...)
    agentic_ns <- asNamespace("agentic")
    tools <- ls(agentic_ns, pattern= "^tool_")
    for (tool in tools) {
      ag$register_tool(agentic_ns[[tool]]())
    }
    ag
}