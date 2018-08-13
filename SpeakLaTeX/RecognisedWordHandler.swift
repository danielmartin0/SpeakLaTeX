import Cocoa
import Foundation

class RecognisedWordHandler: NSObject {
    
    var commandsstring = String()
    var regexstring = String()
    var wordcorrections = [String]()
    var regexcorrections = [[Any]]()
    var wordsToTriggerOSSpeech = [String]()
    var wordsToTriggerDragonSpeech = [String]()
    var vocabList = [[String]]()
    
    func loadCorrectors() {
        if defaults.object(forKey: "commands") != nil {
            commandsstring = (defaults.stringArray(forKey: "commands")?.joined(separator: "\n"))!
        }
        else {
            commandsstring = DEFAULT_COMMANDS.joined(separator: "\n")
        }
        
        wordcorrections = commandsstring.components(separatedBy: "\n").filter{$0[0 ..< 2] != "//"}
        
        
        wordsToTriggerDragonSpeech = []
        wordsToTriggerOSSpeech = []
        vocabList = []
        
        
        var lettersArray: [String]! = ["a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z"]
        
        for correction in wordcorrections {
            var splitcorrection = correction.components(separatedBy: ":")
            var aliases = splitcorrection[0].components(separatedBy: "|")
            if (aliases[0].characters.count > 1 || (aliases[0] == "0" || aliases[0] == "1" || aliases[0] == "2" || aliases[0] == "3" || aliases[0] == "4" || aliases[0] == "5" || aliases[0] == "6" || aliases[0] == "7" || aliases[0] == "8" || aliases[0] == "9")) {
                if aliases[0].characters.first != "!" {
                    wordsToTriggerOSSpeech.append(aliases[0])
                    wordsToTriggerDragonSpeech.append(aliases[0])
                }
                else {
                    wordsToTriggerDragonSpeech.append(aliases[0].substring(from: 1))
                }
                
                for alias in aliases {
                    if (alias.characters.count > 1) {
                    vocabList.append([aliases[0], alias])
                    }
                }
                
                
                if splitcorrection.count == 2 {
                    switch splitcorrection[1] {
                    case "a", " a":
                        lettersArray[0] = aliases[0]
                    case "A", " A":
                        lettersArray[1] = aliases[0]
                    case "b", " b":
                        lettersArray[2] = aliases[0]
                    case "B", " B":
                        lettersArray[3] = aliases[0]
                    case "c", " c":
                        lettersArray[4] = aliases[0]
                    case "C", " C":
                        lettersArray[5] = aliases[0]
                    case "d", " d":
                        lettersArray[6] = aliases[0]
                    case "D", " D":
                        lettersArray[7] = aliases[0]
                    case "e", " e":
                        lettersArray[8] = aliases[0]
                    case "E", " E":
                        lettersArray[9] = aliases[0]
                    case "f", " f":
                        lettersArray[10] = aliases[0]
                    case "F", " F":
                        lettersArray[11] = aliases[0]
                    case "g", " g":
                        lettersArray[12] = aliases[0]
                    case "G", " G":
                        lettersArray[13] = aliases[0]
                    case "h", " h":
                        lettersArray[14] = aliases[0]
                    case "H", " H":
                        lettersArray[15] = aliases[0]
                    case "i", " i":
                        lettersArray[16] = aliases[0]
                    case "I", " I":
                        lettersArray[17] = aliases[0]
                    case "j", " j":
                        lettersArray[18] = aliases[0]
                    case "J", " J":
                        lettersArray[19] = aliases[0]
                    case "k", " k":
                        lettersArray[20] = aliases[0]
                    case "K", " K":
                        lettersArray[21] = aliases[0]
                    case "l", " l":
                        lettersArray[22] = aliases[0]
                    case "L", " L":
                        lettersArray[23] = aliases[0]
                    case "m", " m":
                        lettersArray[24] = aliases[0]
                    case "M", " M":
                        lettersArray[25] = aliases[0]
                    case "n", " n":
                        lettersArray[26] = aliases[0]
                    case "N", " N":
                        lettersArray[27] = aliases[0]
                    case "o", " o":
                        lettersArray[28] = aliases[0]
                    case "O", " O":
                        lettersArray[29] = aliases[0]
                    case "p", " p":
                        lettersArray[30] = aliases[0]
                    case "P", " P":
                        lettersArray[31] = aliases[0]
                    case "q", " q":
                        lettersArray[32] = aliases[0]
                    case "Q", " Q":
                        lettersArray[33] = aliases[0]
                    case "r", " r":
                        lettersArray[34] = aliases[0]
                    case "R", " R":
                        lettersArray[35] = aliases[0]
                    case "s", " s":
                        lettersArray[36] = aliases[0]
                    case "S", " S":
                        lettersArray[37] = aliases[0]
                    case "t", " t":
                        lettersArray[38] = aliases[0]
                    case "T", " T":
                        lettersArray[39] = aliases[0]
                    case "u", " u":
                        lettersArray[40] = aliases[0]
                    case "U", " U":
                        lettersArray[41] = aliases[0]
                    case "v", " v":
                        lettersArray[42] = aliases[0]
                    case "V", " V":
                        lettersArray[43] = aliases[0]
                    case "w", " w":
                        lettersArray[44] = aliases[0]
                    case "W", " W":
                        lettersArray[45] = aliases[0]
                    case "x", " x":
                        lettersArray[46] = aliases[0]
                    case "X", " X":
                        lettersArray[47] = aliases[0]
                    case "y", " y":
                        lettersArray[48] = aliases[0]
                    case "Y", " Y":
                        lettersArray[49] = aliases[0]
                    case "z", " z":
                        lettersArray[50] = aliases[0]
                    case "Z", " Z":
                        lettersArray[51] = aliases[0]
                    default: break
                    }
                }
                
            }
        }
        for i in 0..<52 {
            if (lettersArray[i].characters.first == "!") {
                lettersArray[i] = lettersArray[i].substring(from: 1)
            }
        }
        
        wordsToTriggerDragonSpeech = wordsToTriggerDragonSpeech.filter({$0 != "﻿﻿"}) //Watch out... inside that "" is a weird character. Not sure what it does.
        wordsToTriggerOSSpeech = wordsToTriggerOSSpeech.filter({$0 != "﻿﻿"}) //Watch out... inside that "" is a weird character. Not sure what it does.
        wordsToTriggerOSSpeech = wordsToTriggerOSSpeech.sorted(by: { $0 < $1 })
        
        //a function to eliminate duplicates, from https://stackoverflow.com/questions/34709066/remove-duplicate-objects-in-an-array
        func uniq<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
            var seen: [E:Bool] = [:]
            return source.filter({ (v) -> Bool in
                return seen.updateValue(true, forKey: v) == nil
            })
        }
        
        wordsToTriggerOSSpeech = uniq(source: wordsToTriggerOSSpeech)
        wordsToTriggerDragonSpeech = uniq(source: wordsToTriggerDragonSpeech)
        
        
        
        if defaults.object(forKey: "regex") != nil {
            regexstring = (defaults.stringArray(forKey: "regex")?.joined(separator: "\n"))!
        }
        else {
            regexstring = DEFAULT_REGEX.joined(separator: "\n")
        }
        //regexstring = defaults.stringArray(forKey: "regex")?.joined(separator: "\n") ?? DEFAULT_REGEX.joined(separator: "\n")
        
        
        //        for correction in wordcorrections {
        //            var splitcorrection = correction.components(separatedBy: ": ")
        //            if splitcorrection.count == 1 {splitcorrection = correction.components(separatedBy: ":")}
        //            if (splitcorrection.count > 1) {
        //                if (splitcorrection[0] != "" && splitcorrection[1] != "") {
        //                    regexstring = regexstring.replacingOccurrences(of: "/(?: " + splitcorrection[1] + " )/g", with: " " + splitcorrection[0] + " ", options: .regularExpression, range: nil)
        //                    regexstring = regexstring.replacingOccurrences(of: "/(?: " + splitcorrection[1] + "\n)/g", with: " " + splitcorrection[0] + "\n", options: .regularExpression, range: nil)
        //                }
        //            }
        //        }

        
        regexcorrections = []
        
        for correction in regexstring.components(separatedBy: "\n").filter({$0[0 ..< 2] != "//"}) {
            var splitcorrection = correction.components(separatedBy: "&&&")
            if (splitcorrection.count > 1) {
                if (splitcorrection[0] != "" && splitcorrection[1] != "") {
                    let regex = try? NSRegularExpression(pattern: splitcorrection[0].components(separatedBy: " ").map(correctword).joined(separator: " "), options: NSRegularExpression.Options.dotMatchesLineSeparators)
                    if regex != nil {
                        regexcorrections.append([regex as Any,splitcorrection[1]])
                    }
                }
            }
        }
        
        defaults.set(lettersArray, forKey: "letters")

    }
    
    
    func correctstring(latextext: String) -> String {
        let lowerstring = latextext.lowercased();
        let firstarray = lowerstring.components(separatedBy: " ")
        var firstcorrectedwords = firstarray.map(correctword)
        //HERE IS WHERE WE CHECK IF OS X DICT ALREADY TOOK SOMETHING:
        if firstcorrectedwords[0] == OS_DICT_ALREADY_TOOK_THIS_WORD {
            firstcorrectedwords = Array<String>(firstcorrectedwords.dropFirst())
        }
        let secondstring = correctacrosswords(" " + firstcorrectedwords.joined(separator: " ") + " ")
        
        let secondarray = secondstring.components(separatedBy: " ").filter{$0.characters.count > 0}
        let thirdarray = secondarray.map(correctword)
        return thirdarray.joined(separator: " ")
    }
    
    func correctword(_ word : String) -> String{
        
        var returnword = word
        
        for correction in wordcorrections {
            var pieces = correction.components(separatedBy: ": ")
            if pieces.count == 1 {pieces = correction.components(separatedBy: ":")}
            let aliases = pieces[0].components(separatedBy: "|")
            var command = aliases[0]
            if command.characters.first == "!" {
                command = command.substring(from: 1)
            }
            if (command != "") {
                if (Array<String>(aliases.dropFirst()).contains(word)) {
                    returnword = command
                }
            }
        }
        return returnword
    }
    
    func correctacrosswords(_ words : String) -> String{
        var wordstoreturn = words
        for correction in regexcorrections {
            wordstoreturn = (correction[0] as! NSRegularExpression).stringByReplacingMatches(in: wordstoreturn, range: NSRange(location:0, length:wordstoreturn.characters.count), withTemplate: correction[1] as! String)
        }
        return wordstoreturn
    }
    
    func addRecognisedWordAlias(recognisedWord : String, alias : String, currentTabs: [String]) {
        if (alias != "" && recognisedWord != "") {
            
            var newtabs: [String]! = []
            
            var aliasWritten = false
            for tab in currentTabs {
                
                var reconstructedFile = ""
                
                var firstcorrection = true
                for correction in tab.components(separatedBy: "\n") {
                    var splitcorrection = correction.components(separatedBy: ":")
                    if splitcorrection.count > 1 {
                        var wordandalias = splitcorrection[0].components(separatedBy: "|")
                        let theword = wordandalias[0]
                        if theword == recognisedWord {
                            if !wordandalias.dropFirst().contains(alias) {
                                wordandalias.append(alias)
                                aliasWritten = true
                            }
                        }
                        if firstcorrection == false {
                            reconstructedFile += "\n" + wordandalias.joined(separator: "|") + ":" + splitcorrection.dropFirst().joined(separator: ":")
                        }
                        else {
                            reconstructedFile += wordandalias.joined(separator: "|") + ":" + splitcorrection.dropFirst().joined(separator: ":")
                            firstcorrection = false
                        }
                    }
                    else {
                        if firstcorrection == false {
                            reconstructedFile += "\n" + correction
                        }
                        else {
                            reconstructedFile += correction
                            firstcorrection = false
                        }
                    }
                }
                newtabs.append(reconstructedFile)
            }
            if (aliasWritten == false) {
                //newtabs[0] += "\n" + recognisedWord + "|" + alias
                
                let msg = NSAlert()
                msg.addButton(withTitle: "OK")
                msg.messageText = "No such command word found."
                msg.runModal()
                
            }
            else {
                defaults.setValue(newtabs, forKey: "commands")
                
                appDelegate.MainLaTeXHandler.refreshcommands()
                appDelegate.MainRecognisedWordHandler.loadCorrectors()
            }
        }
    }

}
