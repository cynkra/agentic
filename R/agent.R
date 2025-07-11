#' Create an agent with all agentic tools
#'
#' This function creates an agent using the specified model family (default: 'openai'),
#' registers all available agentic tools, and returns the agent object.
#'
#' @param system_prompt The system prompt. 
#'   If not provided and if a file named `agentic-rules.md` is found in the working directory
#'   its content will be used as the system prompt. 
#'   To force an empty system prompt over 'agentic-rules.md' use `system_prompt = ""`.
#' @param ... Additional arguments passed to the chat function for the provider.
#' @param model The model in the form "provider/model", defaults to "openai/gpt-4.1"
#' @return An Chat object with all agentic tools registered.
#' @examples
#' ag <- agent()
#' ag$chat("What time is it?")
#' @export
agent <- function(system_prompt = NULL, ..., model = NULL) {
  pf <- parent.frame()
  agentic.ask <- getOption("agentic.ask")
  agentic_ns <- asNamespace("agentic")
  if (is.null(system_prompt) && file.exists("agentic-rules.md")) {
    system_prompt <- readLines("agentic-rules.md")
  }
  if (file.exists("agentic-config.yaml")) {
    config <- yaml::read_yaml("agentic-config.yaml")
    model <- model %||% config$global$model
    agentic.ask <- agentic.ask %||% config$global$ask
    config$tools <- lapply(config$tools, \(x) if (is.character(x)) setNames(list(list(list())), x) else x)

    tool_funs <- names(config$tools)
    tools <- lapply(config$tools, \(x) {
      do.call(eval(str2lang(names(x)), pf), do.call(c, x[[1]]))
  })
  } else {
    tool_funs <- ls(agentic_ns, pattern = "^tool_")
    tools <- lapply(do.call, mget(ls(agentic_ns, pattern = "^tool_"), agentic_ns), list())
  }
  model <- model %||% "openai/gpt-4.1"
  model_split <- strsplit(model, "/")[[1]]
  model <- model_split[[2]]
  provider <- model_split[[1]]
  agentic.ask <- agentic.ask %||% "console"
  withr::local_options(agentic.ask = agentic.ask)

  chat_fun_nm <- paste0("chat_", provider)
  chat_fun <- getFromNamespace(chat_fun_nm, "ellmer")

  ag <- chat_fun(system_prompt = system_prompt, model = model, ..., echo = "output")
  for (tool in tools) {
    ag$register_tool(tool)
  }
  ag
}
