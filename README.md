# SpeakLaTeX

SpeakLaTeX is a ready-to-use app for macOS that assists dictation software to write mathematics, typeset in LaTeX.

### Prerequisites

SpeakLaTeX works best with Dragon® for Mac v6, though limited functionality is available on any Mac with dictation tools enabled.

## Getting Started

A compiled executable for SpeakLaTeX is included in this GitHub repository, compatible with macOS 10.10 onwards.

SpeakLaTeX runs as a menu bar application. Once configured to work with Dragon® for Mac, a dictation beginning with a mathematical word will cause Dragon to pass commands to SpeakLaTeX, which will then paste LaTeX into the open window.

For configuration with Dragon® for Mac v6, follow the instructions in the SpeakLaTeX menu under Export… ⟶ Commands for Dragon® for Mac v6 to Desktop.

SpeakLaTeX has documentation within the app for new users.

## Interpretation of speech into LaTeX

The way in which SpeakLaTeX interprets input text into LaTeX is fully customisable from within the app. Interpretation in SpeakLaTeX is controlled by a two-step process.

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

Each command replaces the command word by its defined output on the right. In the case of 'over', the defined output includes two double-quotes. This syntax means that any further output for this string will be placed inside the quotes, unless the special keyword "break" is used.

The output of this dictation will be
```
\frac{ 3 \alpha } { 5 \beta }
```

The stored commands in SpeakLaTeX do most of the heavy lifting, and thus the Regex may be ignored for elementary use. We see that in this case, the Regex served as a shortcut to allow the speaker to omit the word 'fraction'.

## Versioning

The current version of SpeakLaTeX is v1.0.2. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Daniel Martin**

## License

This project is licensed under the GNU Affero General Public License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Dragon® is a trademark of Nuance Communications, Inc., and/or its subsidiaries in the United States and/or other countries.