# This script is run by GitHub Actions for {{workflow_name}}
library(agentic)


## example code to return early if the content doesn't start with "/agent"
# event_path <- Sys.getenv("GITHUB_EVENT_PATH")
# event <- jsonlite::fromJSON(event_path)
# issue_body <- event$issue$body

# # Early return if issue body does not start with '/agent'
# if (!grepl('^/agent', issue_body)) {
#   cat("[agentic] Issue does not start with /agent, exiting.\n")
#   quit()
# }

# Build agent with config and rules
ag <- agent(
  config = ".github/agentic/{{workflow_name}}-config.yaml",
  rules = ".github/agentic/{{workflow_name}}-rules.md"
)

# Run the agent on the issue body
result <- ag$chat(issue_body)

# TODO: example to post output as comment to current issue
