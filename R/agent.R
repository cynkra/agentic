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
#' @param config Path to a config YAML file. Defaults to "agentic-config.yaml".
#' @param rules Path to a rules markdown file. Defaults to "agentic-rules.md".
#' @return An Chat object with all agentic tools registered.
#' @examples
#' ag <- agent()
#' ag$chat("What time is it?")
#' @export
agent <- function(system_prompt = NULL, ..., model = NULL, config = "agentic-config.yaml", rules = "agentic-rules.md") {
  # process args and files 
  config_obj <- config_from_yaml(config, parent.frame())
  system_prompt <- system_prompt %||% system_prompt_from_rules_md(rules)
  tools <- config_obj$tools %||% all_tools()
  model <- model %||% config_obj$model
  agentic.ask <- config_obj$ask %||% getOption("agentic.ask", default = "console")
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
  tool_fun_nms <- ls(ns, pattern = "^tool_")
  tool_funs <-  mget(tool_fun_nms, ns)
  # keep default args for all tools
  empty_args <- list()
  tools <- lapply(tool_funs, function(f) do.call(f, empty_args))
  tools
}

system_prompt_from_rules_md <- function(rules_path) {
  if (file.exists(rules_path)) {
    readLines(rules_path)
  }
}

config_from_yaml <- function(config_path = NULL, env) {
  if (file.exists(config_path)) {
    config <- yaml::read_yaml(config_path)
    config$tools <- lapply(config$tools, get_tool_from_yaml_item, env)
    config
  }
}

get_tool_from_yaml_item <- function(x, env) {
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