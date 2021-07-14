# written-in-elm

- Want to just try the final tool?

Download the index.html

- Want to read the code?

Have a look at Main.elm

- Want to try compiling or running the Elm code locally?

Install Elm ( official instructions - https://guide.elm-lang.org/install/elm.html )

Create a folder with any name and copy the Main.elm and elm.json to
folder/elm.json
folder/src/Main.elm

Run Command Prompt(Windows) / Terminal (Linux/MacOS) inside the folder

Then use the command

elm make src/Main.elm

This will install the dependencies listed in the elm.json
And compile Main.elm to index.html

Then use the command

elm reactor

To start the webpage on locallhost

Now you can make changes to the code in Main.elm and refresh the page to see the changes

Ctrl + C in command prompt to stop the web page

- Some issues I faced on linux

well I couldn't use gunzip to get the elm runtime from the .gz archive

installed peazip to extract it

well I sometimes mess up permissions installing elm by copying it into the appropriate folder using sudo, so..

I copied the binary-for-linux-64-bit to my Home directory
and renamed it to elm

now instead of doing elm <command>, I used ~/elm <command> for example ~/elm reactor to execute elm
