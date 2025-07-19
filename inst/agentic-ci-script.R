# This script is run by GitHub Actions for {{workflow_name}}
library(agentic)

# fetch the context, useful for most workflows
event_path <- Sys.getenv("GITHUB_EVENT_PATH")
event <- jsonlite::fromJSON(event_path)


# example: workflow triggered on issue comment
if (TRUE) {
  issue_comment <- event$comment$body
  # boilerplate to get comment content
  issue_body <- event$issue$body
  # optionally, query only if starts with a command, we could also require a speficic user etc.
  # workflow is triggered anyway but will finish early if not satisfied
  if (!startsWith(issue_comment, "/agent")) {
    writeLines("Agent not required, quitting early")
    quit() # quit R
  }
  # define the agent using appropriate config and rules
  ag <- agent(
    config = ".github/agentic/{{workflow_name}}-config.yaml",
    rules = ".github/agentic/{{workflow_name}}-rules.md"
  )
  # assuming the comment is a question to the agent
  issue_comment <- sub("^/agent", "", issue_comment)
  ag$chat(issue_comment)
}
