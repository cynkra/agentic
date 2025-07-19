#' Set up agentic CI workflow, config, rules, and script for GitHub Actions
#'
#' This function creates a workflow YAML, R script, config YAML, and rules markdown for a CI agentic workflow.
#' @param workflow_name Name for the workflow, script, config, and rules files.
#' @param on Output of an on_*() function (list or YAML string).
#' @param permissions Output of permissions() (list or YAML string).
#' @param secrets character vector of secrets set in github, that you want to access as env vars, it typically includes the llm API key, e.g. "OPENAI_API_KEY" or "ANTHROPIC_API_KEY"
#' @return Invisibly, the paths of the created files.
#' @export
use_agentic_ci <- function(workflow_name, on, permissions, secrets) {
  # create if not created already
  dir.create(".github/agentic", showWarnings = FALSE)

  env_block <- build_env_block(secrets) 
  # unquoting the `on` just to be pretty 
  on_block <- sub("'on'", "on", yaml::as.yaml(list(on = on)))
  permissions_block <- yaml::as.yaml(permissions)

  # Write config, rules, and script files using helpers
  use_agentic_ci_config(workflow_name)
  use_agentic_ci_rules(workflow_name, on_block, permissions_block)
  use_agentic_ci_r_script(workflow_name)
  use_agentic_ci_workflow(workflow_name, on_block, permissions_block, env_block)
}

build_env_block <- function(secrets) {
  secret_block <- sprintf("%s: ${{ secrets.%s }}", secrets, secrets)
  env_block <- c(
    "env:",
    "  GITHUB_EVENT_PATH: ${{ github.event_path }}",
    "  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}",
    paste0("  ", secret_block)
  )
  env_block <- paste(env_block, collapse = "\n")
  env_block
}

use_agentic_ci_config <- function(workflow_name) {
  from <- system.file("agentic-ci-config.yaml", package = "agentic")
  to <- sprintf(".github/agentic/%s-config.yaml", workflow_name)
  file.copy(from, to, overwrite = TRUE)
}

use_agentic_ci_rules <- function(workflow_name, on_block, permissions_block) {
  from <- system.file("agentic-ci-rules.md", package = "agentic")
  content <- readLines(from)
  content <- paste(content, collapse = "\n")
  content <-  gsub("{{workflow_name}}", workflow_name, content, fixed = TRUE)
  content <- sub("{{on_block}}", on_block, content, fixed = TRUE)
  content <- sub("{{permissions_block}}", permissions_block, content, fixed = TRUE)
  to <- sprintf(".github/agentic/%s-rules.md", workflow_name)
  writeLines(content, to)
}

use_agentic_ci_r_script <- function(workflow_name) {
  from <- system.file("agentic-ci-script.R", package = "agentic")
  content <- readLines(from)
  content <- paste(content, collapse = "\n")
  content <- gsub("{{workflow_name}}", workflow_name, content, fixed = TRUE)
  to <- sprintf(".github/agentic/%s.R", workflow_name)
  writeLines(content, to)
}

use_agentic_ci_workflow <- function(workflow_name, on_block, permissions_block, env_block) {
  from <- system.file("agentic-ci-workflow.yaml", package = "agentic")
  content <- readLines(from)
  content <- paste(content, collapse = "\n")
  content <-  gsub("{{workflow_name}}", workflow_name, content, fixed = TRUE)
  content <- sub("{{on_block}}", on_block, content, fixed = TRUE)
  content <- sub("{{permissions_block}}", permissions_block, content, fixed = TRUE)
  content <- sub("{{env_block}}", env_block, content, fixed = TRUE)
  to <- sprintf(".github/workflows/%s.yaml", workflow_name)
  writeLines(content, to)
}

