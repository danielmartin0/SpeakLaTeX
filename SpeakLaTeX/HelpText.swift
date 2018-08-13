import Foundation

let USER_GUIDE_TEXT = "*** Introduction ***\nWelcome to SpeakLaTeX! SpeakLaTeX assists dictation software to write mathematics in LaTeX-formatted documents. It helps you to automate the typing of repetitive phrases and symbols using your voice.\n\nSpeakLaTeX works by receiving input strings in two ways:\n1) From other apps, by the built-in macOS scripting language AppleScript.\n2) From the built-in dictation tool of macOS.\n\nTo enable or disable SpeakLaTeX, simply right click the status bar icon. When enabled, SpeakLaTeX will convert input strings to LaTeX, then paste them to the current window via the system clipboard. When disabled, SpeakLaTeX will paste input strings verbatim.\n\nmacOS dictation can be enabled in the menu.\n\n\n*** Using SpeakLaTeX With External Dictation Software ***\nOther apps can send commands to SpeakLaTeX via AppleScript. Start by configuring your software to talk to SpeakLaTeX. For users of Dragon® v6, follow the instructions under Export… ⟶ Commands for Dragon® for Mac v6 to Desktop.\n\nDragon v6 commands cannot consist of a single word, so to activate SpeakLaTeX from Dragon v6 you need to say more than one word at once. The macOS dictation complements Dragon v6 by interpreting single words in the absence of longer input. It is recommended to enable both, and set Dragon to Command Mode.\n\nYou are now ready to go. For best results a clear microphone is recommended.\n\n\n*** Customizing the Interpretation of Input ***\nYou can fully configure the way SpeakLateX interprets input strings. This is done by editing the commands in the Edit Commands… Window. There are four tabs to help organise your commands.\n\nTake a look at the default commands.\n\nSpeakLaTeX interprets input strings one word at a time. The word is checked against the command words in the Edit Commands Window. Command words are defined as the leftmost word on each line, on the left of the first '|'. If there is a match, the right hand side of the stored command after \": \" or \":\" is added to the output. The other words before \":\" are the aliases for the command word.\n\nA native syntax allows you to create complex output recursively. See Help ⟶ Commands Syntax Reference for more details. Notably, if a command enters a grouping of words but there are no words left in the input string, interpretation is paused until the next input. For example say \"bar\", pause, then say \"x\", to print \\bar{ x }.\n\nPrior to interpretation, each word in the input string (with words defined as being separated by spaces) is checked against the aliases, and if matching any of them, replaced by the associated command word. The entire string is then acted on by a multi-word find-and-replace, implemented by Regular Expressions or 'Regex' (see below). This process corrects for misheard words in the input text.\n\nA shortcut for adding an alias for a given command word is provided by Add Command Alias….\n\n\n*** Regex Replacements ***\nAdvanced users may customise the Regex replacement rules. Recommended materials to learn and use Regex are http://ryanstutorials.net/regular-expressions-tutorial/ for an introductory tutorial, http://regexr.com/ for an excellent online applet to help test Regex expressions, and http://userguide.icu-project.org/strings/regexp for documentation on the ICU Regular Expression syntax used by SpeakLaTeX.\n\nEach line in the Regex Window constitutes one find-and-replace. The Regex and the replacement template are separated by &&&.\n\nBefore the find-and-replace takes place, the input string is appended and prepended with a space. These spaces are removed after the find-and-replace is finished. Their function is to allow the regex \" alpha \" to match all instances of the word alpha, even if alpha is the first or last word of the input string. Remember to include the correct spacing in your custom replacements.\n\nFinally, be aware that upon saving the Regex, every stored Regex is itself checked for the presence of aliases surrounded by two spaces, such as ' offer ', which is snapped to ' alpha '. After the replacements are made to an input string, the input string once more has aliases snapped to command words. This is to avoid the need to rewrite Regex settings when changes are made to the stored commands.\n\n\n*** Troubleshooting ***\nIf the output text is not as expected, check your syntax against the syntax guide and test the relevant Regex at http://regexr.com/. If this does not help you can get in touch at speaklatex@gmail.com.\n"

let SYNTAX_REFERENCE_TEXT = "*** Commands Syntax Reference ***\n\n\n\"\" ——— The quotes are replaced by all of the following interpreted text.\n\n\"subcommandword1: subcommandtext1, subcommandword2|alias2: subcommandtext2\" ——— Like before, but with extra subcommands supplied for the nested interpreted text.\n\n\n££ ——— Replaced by the very next input word.\n\n£subcommandword1: subcommand1, subcommandword2|alias2: subcommandword2£ ——— Like before, but with subcommands.\n\n\n§ ——— New line character.\n\n\n@ ——— Creates a group at this position, but also leaves the blinking text cursor at this location after the dictation is finished.\n\n\n@@ ——— All of the following text in the input is included at this position verbatim, without modification.\n\n\n\":^\" instead of \":\", after the aliases ——— Each following word is appended by the text after ^, but before the next space.\n\n\":_\" instead of \":\", after the aliases ——— The same, but for prepending rather than appending.\n\n\":!_\" instead of \":\", after the aliases ——— The same, except the first following word is not prepended.\n\n\n// ——— Commented out line.\n\n\n\n\n*** Further Details ***\n\nThe easiest way to learn the native syntax is to consult the default commands for worked examples. Many of these examples require the 'amsmath' package in LaTeX. Further, more detailed points are listed here.\n\n\nIf the input string ends whilst entering \"\" or ££, interpretation pauses until the next input.\n\nInput strings consisting of a single word will never break out of a \"\".\n\n'break' is a built-in keyword that always breaks out of the enclosing \"\".\n\nStored commands have the structure\ncommandword|alias1|alias2: commandtext\nEither \": \" or \":\" can be used to separate aliases from the commandtext.\n\nCommand words must be a word and not contain any spaces.\n\nPrepend command words with an exclamation mark to prevent those command words being used by macOS dictation:\n!commandword|alias1|alias2: commandtext\nThis is useful for commands which are easy to trigger by ambient noises.\n\nCommands with no command word have the structure\n|alias1|alias2: commandtext\nThese commands have no command word to export to Dragon or macOS dictation, but can still be activated via their aliases.\n\nCommand words that are single letters or symbols will not be exported to Dragon or macOS dictation.\n\nSubcommands are always prepended to the remaining input string rather than being included directly in the output. This means that subcommands can activate other stored commands by name.\n\nEvery activated command will be followed by a space, unless the command text contains a @ character.\n\nThe final trailing space is trimmed from nested text within \"\" or ££ groups, allowing you to control the spacing of grouped text more precisely.\n\nCertain words appear to crash Dragon when imported in as command words: \"size\", \"empty\" and \"hash\". The reason for this is unknown and there are presumably more such words of which we are not aware. Currently those three words are blocked from being exported.\n"
