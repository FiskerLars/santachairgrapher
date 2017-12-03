# santachairgrapher

## FIXME

- lazyness seems to be in the way of evaluating the CLI version. Only the interactive ghci call to Lib.cookieAssignments seems to work. But provides a neat output for all the cookie recipients.


## Running and Compiling under windows

There have been problems to find the correct ghc in the path. The only version I can find on my path is ghc 7.10.2. As I couldn't find a quick way to install a new one, or to direct the path into the right direction, I used an aged resolver. I found lts-3.22 is using the right version of ghc.

This obviously is a nasty kludge that I want to get rid of, but I leave this to programming under a real operating system.

Thus, I use the follwing lines to compile my code:

$ stack build --resolver lts-3.22

or to use the Lib interactively

$ stack ghci --resolver lts-3.22