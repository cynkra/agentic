library(ellmer)
chat <- chat_openai(model = "gpt-4o")
# LLMs don't know what time is it
chat$chat("What time is it?")

constructive::construct(tu)
# but we can write a function to provide this info given an optional timezone arg
get_current_time <- function(tz = "UTC") {
  format(Sys.time(), tz = tz, usetz = TRUE)
}
# and we can embed this function in what we call a tool, along with a description of what it does and what its arguments are
tool_current_time <- tool(
  get_current_time,
  "Gets the current time in the given time zone.",
  tz = type_string(
    "The time zone to get the current time in. Defaults to `\"UTC\"`.",
    required = FALSE
  )
)

# once we register the tool to the chat we can ask the question again and it works
chat$register_tool(tool_current_time)

chat$chat("What time is it?")

#oops it gave US UTC time!

chat$chat("We're in Switzerland")

wait <- function(t) {
    for(i in seq(t)) {
        Sys.sleep(1)
        # for debugging purposes we print a dot each sec
        cat(".")
    }
}

tool_wait <- tool(
  wait,
  "Waits for some time",
  t = type_integer(
    "Number of seconds to wait",
    required = TRUE
  )
)

chat$register_tool(tool_wait)

chat$chat("wait 3 sec")

chat$chat("give me the time, then wait 3 sec and give me the time again")
chat$chat("give me the current time 3 times, waiting for 2 seconds in between")


chat$register_tool(tool_screenshot)

chat$chat("capture my screen")

chat$chat


chat$register_tool(tool_multiple_choices)
chat$chat("I don't know where to go for my next vacation, ask me multiple choices questions and give me the best picl")


iris_ <- function() {
  message("!!!")
  iris
}

tool_iris <- tool(
  iris_,
  "provides the iris dataset",
)

chat$register_tool(tool_iris)






chat$chat("print  the content of my clipboard to  upper case")
chat$chat("print  the content of my clipboard")




chat <- chat_openai(model = "gpt-4o")
chat$register_tool(tool_clipboard_content)
chat$register_tool(tool_copy_to_clipboard)
# "hello there!"
chat$chat("convert the content of my clipboard to upper case")

chat$chat_structured(
  "print the content of my clipboard to upper case",
  type = type_object(
    #"A structured response containing the minimal raw answer and optionally extra information",
    #introduction = type_string("An introduction sentence. Optional and usually better avoided", required = FALSE),
    #conclusion = type_string("An conclusion sentence. Optional and usually better avoided", required = FALSE),
    raw_output = type_string("The output that was requested by the prompt, in minimal form."),
    extra = type_string("context, comment, information, explaination or suggestion. Optional and usually better avoided", required = FALSE)
  )
)

chat <- chat_openai(model = "gpt-4o")
chat$register_tool(tool_run_terminal_command)
chat$chat("how much disk space do i have left?")
chat$chat("When was my last commit to ../contructive ?")



  req <- httr::GET(
    "https://gmail.googleapis.com/gmail/v1/users/me/threads",
    query = "LLM",
    gmailr::gm_token())
  parsed <- httr::content(req, "parsed")
  parsed




chat <- chat_openai(model = "gpt-4o")
chat$register_tool(tool_query_image)
chat$register_tool(tool_screenshot2)
chat$register_tool(tool_left_click)
# chat$register_tool(tool_screen_resolution)
# chat$register_tool(tool_image_metadata)
chat$chat("navigate to the tool_working_directory.R tab you should be able to compu")

chat <- chat_openai(model = "gpt-4o")
chat$register_tool(tool_query_image)
chat$register_tool(tool_screenshot)
chat$chat("Please locate the center of the tool_working_directory.R tab with x and y coordinates")

res <- system("/usr/sbin/system_profiler SPDisplaysDataType | grep Resolution", intern = TRUE)
# Example output: "Resolution: 2560 x 1600 Retina"
# Parse it:
dims <- as.integer(unlist(regmatches(res, gregexpr("\\d+", res))))
width <- dims[1]
height <- dims[2]


