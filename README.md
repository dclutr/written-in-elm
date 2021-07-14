# written-in-elm

A. Want to just try the final tool?

Download the index.html

B. Want to read the code?

Have a look at Main.elm

C. Want to try compiling or running the Elm code locally?

1. Install Elm ( official instructions - https://guide.elm-lang.org/install/elm.html )

2. Create a folder with any name and copy the "elm.json" and "Main.elm" to

folder/elm.json

folder/src/Main.elm

3. Run Command Prompt(Windows) / Terminal (Linux/MacOS) inside the folder

4. Then use the command

elm make src/Main.elm

This will install the dependencies listed in the elm.json
And compile Main.elm to index.html

5. Then use the command

elm reactor

To start the webpage on locallhost

Now you can make changes to the code in Main.elm and refresh the page to see the changes

6. Ctrl + C in command prompt to stop the web page

D. Some issues I faced on linux

well I couldn't use gunzip to get the elm runtime from the .gz archive

installed peazip to extract it

well I need to copy elm to the appropriate folder using sudo, so that I can run commands like elm reactor, elm make..

but I mess up the permissions and dont want to deal with it

I copied the binary-for-linux-64-bit in the .gz archive to my Home directory
and renamed it to elm

now instead of doing elm reactor, I do ~/elm reactor and I can execute other elm commands in a similar way
