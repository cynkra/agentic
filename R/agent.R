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

  # process args and files 
  config <- config_from_yaml(pf)
  system_prompt <- system_prompt %||% system_prompt_from_rules_md()
  tools <- config$tools %||% all_tools()
  model <- model %||% config$model
  agentic.ask <- config$ask %||% getOption("agentic.ask", default = "console")
  mp <- fetch_model_and_provider(model)

  # create chat and register tools
  withr::local_options(agentic.ask = agentic.ask)
  chat_fun_nm <- paste0("chat_", mp[["provider"]])
  chat_fun <- getFromNamespace(chat_fun_nm, "ellmer")
  ag <- chat_fun(system_prompt = system_prompt, model = mp[["model"]], ..., echo = "output")
  for (tool in tools) {
    ag$register_tool(tool)
  }
  ag
}

all_tools <- function() {
  agentic_ns <- asNamespace("agentic")
  tool_fun_nms <- ls(agentic_ns, pattern = "^tool_")
  tool_funs <-  mget(tool_fun_nms, agentic_ns)
  # keep default args for all tools
  empty_args <- list()
  tools <- lapply(tool_funs, function(f) do.call(f, empty_args))
  tools
}

system_prompt_from_rules_md <- function() {
  if (file.exists("agentic-rules.md")) {
    readLines("agentic-rules.md")
  }
}

config_from_yaml <- function(env) {
  if (file.exists("agentic-config.yaml")) {
    config <- yaml::read_yaml("agentic-config.yaml")
    config$tools <- lapply(config$tools, tool_from_yaml_item, env)
    config
  }
}

tool_from_yaml_item <- function(x, env) {
  if (is.character(x)) {
    tool_fun <- eval(str2lang(x), env)
    tool <- do.call(tool_fun, list())
    return(tool)
  }
  tool_fun <- eval(str2lang(names(x)), env)
  tool <- do.call(tool_fun, x[[1]])
  tool
}

fetch_model_and_provider <- function(model) {
  model <- model %||% "openai/gpt-4.1"
  model_provider <- strsplit(model, "/")[[1]]
  names(model_provider) <- c("provider", "model")
  model_provider
}