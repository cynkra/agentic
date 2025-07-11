
<!-- README.md is generated from README.Rmd. Please edit that file -->

# agentic

Warning: Experimental, potentially unsafe, and many functions work only
on mac

`agentic` provides a set of R functions to enhance the interaction of
large language models (LLMs) with your system. It is designed to work
with the [`ellmer`](https://github.com/tidyverse/ellmer) package and
enables LLMs to access the clipboard, files, mouse, system information,
and more. This makes it easy to build powerful, interactive agents in R.

## Installation

You can install the development version of agentic from GitHub with:

``` r
pak::pak("cynkra/agentic")
```

## Example

LLMs don’t know anything about your system, you could tell them, or you
could give them tools to fetch the info themselves.

``` r
library(agentic)

# Create a chat instance with OpenAI
chat <- ellmer::chat_openai(model = "gpt-4o")

# it can't know
chat$chat("What time is it?")
#> I'm unable to provide real-time information, including the current time. You 
#> can check the time on your device or a clock nearby.

# unless we allow it to access this info
chat$register_tool(tool_current_time())

# Ask the LLM to get the time
chat$chat("What time is it?")
#> ◯ [tool call] get_current_time(tz = "UTC")
#> ● #> 2025-07-11 08:17:36 UTC
#> The current time in UTC is 08:17 AM on July 11, 2025.

# oops wrong timezone
chat$chat("I'm in Switzerland")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-11 10:17:38 CEST
#> The current time in Switzerland (Europe/Zurich timezone) is 10:17 AM on July 
#> 11, 2025.
```

Tools can do more than provide context, they can do side effects, these
includes running terminal commands, taking screenshots, clicking etc.

Or simply wait as we do bellow:

``` r
chat$register_tool(tool_wait())

# there's a little overhead of course
system.time(
  chat$chat("pause for 7 seconds")
)
#> ◯ [tool call] wait(t = 7L)
#> .......
#> ● #> {}
#> Paused for 7 seconds as requested. What would you like to do next?
#>    user  system elapsed 
#>   0.396   0.005   8.884
```

Where it gets very interesting is that the llms will combine tools and
call one several times if needed.

``` r
chat$chat("give me the time, then wait 3 sec and give me the time again")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-11 10:17:49 CEST
#> ◯ [tool call] wait(t = 3L)
#> ...
#> ● #> {}
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-11 10:17:54 CEST
#> The first time was 10:17:49 AM, and after waiting for 3 seconds, the time is 
#> now 10:17:54 AM in Switzerland.
```

Let’s do a fancier example, I’m typing this using cursor, and I want to
use the find and replace feature. You’ll notice the wording is very
specific, sometimes to make it work reliably it’s necessary to play
around a bit.

``` r
chat <- ellmer::chat_openai(model = "gpt-4o")
chat$register_tool(tool_screenshot())   # to be able to take a screenshot
chat$register_tool(tool_query_image())  # to be able to analyse the screenshot
chat$register_tool(tool_system_info())  # to be able to request system info
chat$register_tool(tool_keypress())     # to be able to use hotkeys
chat$chat("First find out what is the hotkey to open the global find and replace widget for my app and system, then and only then use a tool as a second step to trigger it")
#> ◯ [tool call] system_info()
#> ● #> sysname
#>   #> "Darwin"
#>   #> release
#>   #> "24.5.0"
#>   #> version
#>   #> …
#> ◯ [tool call] screenshot()
#> ● #> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//Rtmpm6jwt9/file8cb65d0a…
#> ◯ [tool call] query_image(query = "Which application is currently open in the
#> foreground?", img_path =
#> "/var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//Rtmpm6jwt9/file8cb65d0ac1d1.png")
#> ● #> <Turn: assistant>
#>   #> The application currently open in the foreground is Visual Studio Code.
#> You are using Visual Studio Code on a macOS system. The hotkey for opening the 
#> global find and replace widget in Visual Studio Code on macOS is typically 
#> `Command` + `Shift` + `H`.
#> 
#> Now, I'll use this hotkey to trigger the global find and replace widget for 
#> you.
#> ◯ [tool call] keypress(key = "H", control = NULL, command = TRUE, shift = TRUE,
#> option = NULL, fn = NULL)
#> ● #> true
#> I've triggered the global find and replace widget in Visual Studio Code using 
#> the hotkey `Command` + `Shift` + `H`. If you need further assistance, feel free
#> to ask!
```

Here’s a list of the current tools.

``` r
grep("^tool_", getNamespaceExports("agentic"), value = TRUE)
#>  [1] "tool_query_image"          "tool_image_metadata"      
#>  [3] "tool_clipboard_content"    "tool_left_click"          
#>  [5] "tool_file_copy"            "tool_write_to_file"       
#>  [7] "tool_current_time"         "tool_double_left_click"   
#>  [9] "tool_right_click"          "tool_play_audio_file"     
#> [11] "tool_run_terminal_command" "tool_session_info"        
#> [13] "tool_speech_to_text"       "tool_read_from_file"      
#> [15] "tool_file_delete"          "tool_list_files"          
#> [17] "tool_file_rename"          "tool_multiple_choices"    
#> [19] "tool_keypress"             "tool_run_r_command"       
#> [21] "tool_working_directory"    "tool_screen_resolution"   
#> [23] "tool_text_to_speech"       "tool_browse_url"          
#> [25] "tool_wait"                 "tool_text_input"          
#> [27] "tool_screenshot"           "tool_copy_to_clipboard"   
#> [29] "tool_cursor_position"      "tool_system_info"         
#> [31] "tool_record_audio"
```

## putting it all together

If you don’t feel like registering manually all tools and are not afraid
of your system gaining sentience you might use the `agent()` function.
It is just like `ellmer::chat_*()` functions (defaulting on chatgpt),
but has all the tools of this package preregistered.

IMPORTANT: There are no good safeguards in place at the moment to
prevent the llm to write or remove files, format your drive etc. Be
careful!

``` r
ag <- agent()
ag$chat("How much drive space do I have left? answer in a warning popup")
ag$chat("I don't know where to go for my next vacation, ask me interactive multiple choice questions and give me the best pick!")
```
