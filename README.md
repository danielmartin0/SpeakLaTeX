# SpeakLaTeX
https://github.com/danielmartin0/SpeakLaTeX


SpeakLaTeX 1.0.2 is a ready-to-use app for macOS that assists dictation software to write mathematics, typeset in LaTeX. It receives text input from dictation software, and then pastes the text, interpreted as LaTeX.

An example of SpeakLaTeX in use with Dragon® for Mac v6 is on YouTube at https://www.youtube.com/watch?v=ay1LyHgUIjY.

## Prerequisites

macOS 10.10 or later is required.

SpeakLaTeX is intended for use with Dragon® for Mac v6. Limited functionality (dictation one word at a time) is available on any Mac with dictation tools enabled.

A microphone that can pick up clear speech is required.

## Getting Started

A compiled executable for SpeakLaTeX is included at https://github.com/danielmartin0/SpeakLaTeX/releases. Simply download it and move it to the applications folder to run. The app runs as a menu bar application in the top right of the screen.

For configuration with Dragon® for Mac v6, follow the instructions in the SpeakLaTeX menu under Export… ⟶ Commands for Dragon® for Mac v6 to Desktop. Once configured, a dictation to Dragon that starts with a mathematical word will cause Dragon to pass commands to SpeakLaTeX, which will then paste LaTeX into the open window.

New users should consult the app's Help section.

## Interpretation of speech into LaTeX

The way in which SpeakLaTeX interprets input text into LaTeX is fully customisable from within the app. The interpretation settings are stored locally on the computer, and can be exported or imported (again from within the app). Interpretation in SpeakLaTeX is controlled by a two-step process.

An isolated input string is delivered to SpeakLaTeX, e.g.:
```
three alpha over five beta
```
The first step is for a set of find-and-replace regular expressions ('Regex') to act on the string. The default settings take this to:
```
fraction three alpha over five beta
```
Next, the string is read left to right, and each word (defined as text separated by spaces) is examined against a list of SpeakLaTeX command words. In this case, the relevant default SpeakLaTeX commands are:
```
alpha|balfour|offer|author|hoffer: \alpha
beta|baiters|beater|better|metre|peter|baiters|baiter|bait|data|beatty|leader: \beta
fraction|friction|correction|flexion|fractures|fracture|actions|action|fractured|sections|section|traction|functions|function|fractional|fractions: \frac{
over|other: }{ "" }
```
Observe that any of a set of similar-sounding aliases activate this command. This is to correct for misheard words.

Each command replaces the command word by its defined output on the right. In the case of 'over', the defined output includes two double-quotes. This syntax means that any further output for this string will be placed inside the quotes, unless the special keyword "break" is used. Further syntax details are available within the app or at https://github.com/danielmartin0/SpeakLaTeX/wiki.

The output of this dictation will be
```
\frac{ 3 \alpha } { 5 \beta }
```

The stored commands in SpeakLaTeX do most of the heavy lifting, and thus the Regex may be ignored for elementary use. We see that in this case, the Regex served as a shortcut to allow the speaker to omit the word 'fraction'.

With help from the documentation, and by examining the default commands, customize SpeakLaTeX to your will. User settings are stored locally on the machine, and can be exported and imported if you change machine. I'd appreciate any snippets of SpeakLaTeX code that you'd like to share - send them to speaklatex@gmail.com.

## Authors

* **Daniel Martin**

## Contribute

SpeakLaTeX is written in Swift and released under the GNU Affero General Public License. This app was originally developed for commercial released and then was switched to open-source. Please contact the author if you'd like to assist him on development.

Comments or questions welcome at speaklatex@gmail.com.

## Acknowledgments

Dragon® is a trademark of Nuance Communications, Inc., and/or its subsidiaries in the United States and/or other countries.

Thanks to Lulie Tanett for her graphical work in creating the app icons.
