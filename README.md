
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
#> I'm sorry, but I can't provide real-time information. Please check the clock on
#> your device or another source for the current time.

# unless we allow it to access this info
chat$register_tool(tool_current_time())

# Ask the LLM to get the time
chat$chat("What time is it?")
#> Please provide your time zone, so I can tell you the current time there.

# oops wrong timezone
chat$chat("I'm in Switzerland")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:37:55 CEST
#> The current time in Switzerland (Europe/Zurich) is 15:37 (3:37 PM) on July 4, 
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
#> Paused for 7 seconds. How can I assist you further?
#>    user  system elapsed 
#>   0.391   0.007   9.434
```

Where it gets very interesting is that the llms will combine tools and
call one several times if needed.

``` r
chat$chat("give me the time, then wait 3 sec and give me the time again")
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:38:07 CEST
#> ◯ [tool call] wait(t = 3L)
#> ...
#> ● #> {}
#> ◯ [tool call] get_current_time(tz = "Europe/Zurich")
#> ● #> 2025-07-04 15:38:11 CEST
#> - The current time in Switzerland (Europe/Zurich) is 15:38:07 (3:38:07 PM).
#> - After waiting for 3 seconds, the time is now 15:38:11 (3:38:11 PM).
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
#> ● #> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//RtmpbTFbRv/file127cf6c0…
#> ◯ [tool call] query_image(query = "What application is currently open in the
#> screenshot?", img_path =
#> "/var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//RtmpbTFbRv/file127cf6c06e8eb.png")
#> ● #> <Turn: assistant>
#>   #> The application open in the screenshot is Visual Studio Code.
#> ◯ [tool call] keypress(key = "f", control = TRUE, command = NULL, shift = TRUE,
#> option = FALSE, fn = NULL)
#> ● #> true
#> I have triggered the hotkey for opening the "Find and Replace" widget in Visual
#> Studio Code on macOS, which is `Command` + `Shift` + `F`.
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
```
