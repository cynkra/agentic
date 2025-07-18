# Agentic Rules for {{workflow_name}}

- This agent is running in a GitHub Actions CI environment.
- The workflow is triggered by:

```
{{on_block}}
```

- The workflow permissions are:

```
{{permissions_block}}
```

- The following tools are available:
  - tool_run_terminal_command
  - tool_run_r_command
  - tool_ga_event_context
  - tool_ga_api 
