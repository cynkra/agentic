
<!-- README.md is generated from README.Rmd. Please edit that file -->

# agentic

Warning: Experimental, potentially unsafe, and many functions work only
on mac

`agentic` provides a set of R functions to enhance the interaction of
large language models (LLMs) with your system. It is designed to work
with the [`ellmer`](https://github.com/tdyverse/ellmer) package and
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
#> I'm unable to provide real-time information or updates, including the current 
#> time. You might want to check a clock or use a device like a smartphone or 
#> computer for that information.

# unless we allow it to access this info
chat$register_tool(tool_current_time())

# Ask the LLM to get the time
chat$chat("What time is it?")
#> ◯ [tool call] get_current_time(tz = NULL)
#> ● #> 2025-07-04 13:49:25 UTC
#> The current time is 13:49 (UTC) on July 4th, 2025.

# oops wrong timezone
chat$chat("I'm in Switzerland")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:49:28 CEST
#> The current time in Switzerland (Europe/Zurich time zone) is 15:49 on July 4th,
#> 2025.
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
#> Paused for 7 seconds as requested. Let me know if there's anything else I can 
#> do for you!
#>    user  system elapsed 
#>   0.389   0.007   9.384
```

Where it gets very interesting is that the llms will combine tools and
call one several times if needed.

``` r
chat$chat("give me the time, then wait 3 sec and give me the time again")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:49:39 CEST
#> ◯ [tool call] wait(t = 3L)
#> ...
#> ● #> {}
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:49:44 CEST
#> The time before waiting was 15:49:39 (CEST).
#> 
#> After waiting for 3 seconds, the time is now 15:49:44 (CEST).
```

Let’s do a fancier example, I’m typing this using cursor, and I want to
make sure all my files are saved

``` r
chat <- ellmer::chat_openai(model = "gpt-4o")
chat$register_tool(tool_screenshot())   # to be able to take a screenshot
chat$register_tool(tool_query_image())  # to be able to analyse the screenshot
chat$register_tool(tool_system_info())  # to be able to request system info
chat$register_tool(tool_keypress())     # to be able to use hotkeys
chat$chat("Find out what the hotkey is to open the find and replace widget for my app and system, then trigger it")
#> ◯ [tool call] system_info()
#> ● #> sysname
#>   #> "Darwin"
#>   #> release
#>   #> "24.5.0"
#>   #> version
#>   #> …
#> ◯ [tool call] screenshot()
#> ● #> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//Rtmp0G3s7u/file12e9d6f3…
#> ◯ [tool call] query_image(query = "Which app is open in the screenshot?",
#> img_path =
#> "/var/folders/mp/qvg2y_jx63bgkk_s0xxh2zr140000gp/T//Rtmp0G3s7u/file12e9d6f3e7dac.png")
#> ■ #> Error:
#>   #>
#> /var/folders/mp/qvg2y_jx63bgkk_s0xxh2zr140000gp/T//Rtmp0G3s7u/file12e9d6f3e7dac.png
#>   #> must be an existing file.
#> It seems there was an issue with accessing the screenshot to determine the open
#> application. Let me retake the screenshot and query the image again.
#> ◯ [tool call] screenshot()
#> ● #> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//Rtmp0G3s7u/file12e9d6fa…
#> ◯ [tool call] query_image(query = "Which app is open in the screenshot?",
#> img_path =
#> "/var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//Rtmp0G3s7u/file12e9d6face042.png")
#> ● #> <Turn: assistant>
#>   #> The app open in the screenshot is Visual Studio Code.
#> For Visual Studio Code on macOS, the hotkey to open the Find and Replace widget
#> is usually `Command` + `Option` + `F`. I will now simulate this keypress for 
#> you.
#> ◯ [tool call] keypress(key = "f", control = NULL, command = TRUE, shift = NULL,
#> option = TRUE, fn = NULL)
#> ● #> true
#> I've triggered the "Find and Replace" hotkey for Visual Studio Code. You should
#> now see the widget open in the app.
```

Here’s a list of the current tools.

``` r
grep("^tool_", getNamespaceExports("agentic"))
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
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
ag$chat("I don't know where to go for my next vacation, ask me multiple choices questions and give me the best pick!")
```
