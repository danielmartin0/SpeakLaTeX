let NEW_LINE_DELIMITER = "§"
let LOOP_COMMAND_DELIMITER = "\""
let WORD_COMMAND_DELIMITER = "£"
let POINTER_DELIMITER = "@"
let REPEATER_DELIMITER = "$"

var BONUS_TEXT_FOR_NEXT_TIME = [String]()
var BONUS_LOOP_TYPE_FOR_NEXT_TIME = [String]() //element can be "word" or "multi"
var BONUS_PREPEND_FOR_NEXT_TIME = [String]()
var BONUS_APPEND_FOR_NEXT_TIME = [String]()
var BONUS_LOOP_COMMANDS_FOR_NEXT_TIME = [[String]]()
var BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME = [Bool]()
var ADD_BONUS_TEXT_FOR_NEXT_TIME = ""
var ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME = "" //element can be "word" or "multi"
var ADD_BONUS_PREPEND_FOR_NEXT_TIME = ""
var ADD_BONUS_APPEND_FOR_NEXT_TIME = ""
var ADD_BONUS_LOOP_COMMANDS_FOR_NEXT_TIME = [String]()
var ADD_BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME = false

var ARRAY_OF_VERBATIM_TEXT = [String]()

import Cocoa

class LaTeXHandler: NSObject {
    var builtInCommandsList = [[String]]()
    var builtInVerbatimList = [[String]]()
    
//    var loopRecord = [String]()
//    var loopNumber = 1
    
    var gobackwithcursor = -1
    
    override init() {
        super.init()
        
        self.refreshcommands()
    }
    
    func refreshcommands() {
        var firstCommandsList = [String]()
        if defaults.object(forKey: "commands") != nil {
            for tab in (defaults.stringArray(forKey: "commands"))! {
                firstCommandsList += tab.components(separatedBy: "\n")
            }
        }
        else {
            for tab in DEFAULT_COMMANDS {
                firstCommandsList += tab.components(separatedBy: "\n")
            }
        }
        firstCommandsList = firstCommandsList.filter({$0[0 ..< 2] != "//"})
        builtInCommandsList = []
        builtInVerbatimList = []
        for command in firstCommandsList {
            var varcommand = command
            if varcommand.characters.first == "!" {
                varcommand = varcommand.substring(from: 1)
            }
            if varcommand.contains(String(POINTER_DELIMITER) + String(POINTER_DELIMITER)) {
                var splitCommand = varcommand.components(separatedBy: ": ")
                if splitCommand.count < 2 {splitCommand = varcommand.components(separatedBy: ":")}
                if (splitCommand.count > 1) {
                    let splitCommand2 = splitCommand[1].components(separatedBy: String(POINTER_DELIMITER) + String(POINTER_DELIMITER))
                    builtInVerbatimList.append([splitCommand[0],splitCommand2[0],splitCommand2[1]])
                }
            }
            else {
                builtInCommandsList.append(varcommand.components(separatedBy: ":"))
            }
        }
        builtInCommandsList = builtInCommandsList.filter({$0.count > 1})
        // ?? DEFAULT_COMMANDS
    }
    
    func writeLaTeX(dictation: String) {
        
        gobackwithcursor = -1;
        
        let result = interpretDictation(dictation: dictation)

        
        writeViaClipboard(text: result)
        
        if self.gobackwithcursor != -1 {
            pressLeftKeyRepeatedly(times: self.gobackwithcursor)
        }
        
        //return result
    }
    
    func interpretDictation(dictation: String) -> String {
        
        
        var tempdictarray = dictation.components(separatedBy: " ")
        
        //deal with possible verbatim words, like type, color, etc:
        var dictarray = [String]()
        var textToPrintVerbatim = ""
        var textToPrintAfterVerbatim = ""
        var verbatimMode = false
        var firstwordprintedverbatim = true
        
        var breakOutOfLoop = false
        var saveAdditionalTextForNextTime = false
        
        for word in tempdictarray {
            verbmode: if verbatimMode == false {
                for verbatim in builtInVerbatimList {
                    for alias in verbatim[0].components(separatedBy: "|") {
                        if word == alias {
                            verbatimMode = true
                            textToPrintVerbatim = verbatim[1]
                            textToPrintAfterVerbatim = verbatim[2] + " "
                            break verbmode;
                        }
                    }
                }
                dictarray.append(word)
            }
            else {
                if firstwordprintedverbatim == true {
                    textToPrintVerbatim += word
                    firstwordprintedverbatim = false
                }
                else {
                    textToPrintVerbatim += " " + word
                }
            }
        }
        if dictarray.count == 0 {return textToPrintVerbatim + textToPrintAfterVerbatim}
        
        dictarray = appDelegate.MainRecognisedWordHandler.correctstring(latextext: dictarray.joined(separator: " ")).components(separatedBy: " ")
        
        if verbatimMode == true {
            dictarray.append("verbatimTextPlaceholder") //something which, when interpreted, recalls the verbatimtext!
            ARRAY_OF_VERBATIM_TEXT.append(textToPrintVerbatim + textToPrintAfterVerbatim)
        }
        
//        print(dictarray)
//        if (dictarray.joined(separator: " ") == ONPHRASE && SPEAKLATEX_ACTIVE == false) {
//            enableSpeakLaTeX()
//            return ""
//        }
//        if (dictarray.joined(separator: " ") == OFFPHRASE && SPEAKLATEX_ACTIVE == true) {
//            disableSpeakLaTeX()
//            return ""
//        }
        
        func interpretCommand(command: String) -> String{
            var stringtoreturn = ""
            
            var appendEachWord = ""
            var prependEachWord = ""
            
            var fixedcommand = command

            //first check for ^ or _ at the start, otherwise chop until we hit a space
            
            var delayoneprepend = false
            
            if fixedcommand.characters.count > 1 {
                switch fixedcommand[0]{
                case "^":
                    fixedcommand = fixedcommand.substring(from: 1)
                    
                    let nextspace = fixedcommand.characters.index(of: " ")
                    if nextspace != nil {
                        appendEachWord = fixedcommand.substring(to: nextspace!)
                        fixedcommand = fixedcommand.substring(from: nextspace!)
                    }
                    else {
                        appendEachWord = fixedcommand.substring(to: fixedcommand.endIndex)
                    }
                    break;
                case "_":
                    fixedcommand = fixedcommand.substring(from: 1)
                    
                    let nextspace = fixedcommand.characters.index(of: " ")
                    if nextspace != nil {
                        prependEachWord = fixedcommand.substring(to: nextspace!)
                        fixedcommand = fixedcommand.substring(from: nextspace!)
                    }
                    else {
                        prependEachWord = fixedcommand.substring(to: fixedcommand.endIndex)
                    }
                    break;
                case "!":
                    if fixedcommand.characters.count > 2 {
                        if fixedcommand[1] == "_" {
                            fixedcommand = fixedcommand.substring(from: 2)
                            
                            delayoneprepend = true
                            let nextspace = fixedcommand.characters.index(of: " ")
                            prependEachWord = fixedcommand.substring(to: nextspace!)
                            fixedcommand = fixedcommand.substring(from: nextspace!)
                        }
                    }
                    break;
                default: break;
                }
                
                if fixedcommand.characters.count > 1 {
                    if fixedcommand.characters.first == " " {
                        fixedcommand = fixedcommand.substring(from: 1)
                    }
                }
            }
            
            // switch between 'normal text' and stuff read from inside a loop
            var normaltext = true
            var nexttimeinstead = false
            for bit in fixedcommand.components(separatedBy: LOOP_COMMAND_DELIMITER) {
                    if normaltext == true {
                        for bitb in bit.components(separatedBy: WORD_COMMAND_DELIMITER) {
                            if normaltext == true {
                                if nexttimeinstead == true {
                                    ADD_BONUS_TEXT_FOR_NEXT_TIME += bitb
                                }
                                else {
                                    var pointerComponents = bitb.components(separatedBy: POINTER_DELIMITER)
                                    while pointerComponents.count > 0 {
                                        let pointerComponent = pointerComponents[0]
                                        pointerComponents.removeFirst()
                                        if pointerComponent != "" {
                                            if saveAdditionalTextForNextTime == false {
                                                stringtoreturn += pointerComponent
                                            }
                                            else {
                                                ADD_BONUS_TEXT_FOR_NEXT_TIME += pointerComponent
                                            }
                                            //stringtoreturn += pointerComponent
                                        }
                                        if pointerComponents.count > 0 {
                                            breakOutOfLoop = false
                                            
                                            if saveAdditionalTextForNextTime == false {
                                                stringtoreturn += LaTeXLoop(extraCommandAliases: [String](), prependEachWord: "", appendEachWord: "", delayoneprepend: false) + POINTER_DELIMITER
                                            }
                                            else {
                                                ADD_BONUS_TEXT_FOR_NEXT_TIME += LaTeXLoop(extraCommandAliases: [String](), prependEachWord: "", appendEachWord: "", delayoneprepend: false) + POINTER_DELIMITER
                                            }
                                            //stringtoreturn += littlestringtoreturn
                                        }
                                    }
                                }
                            } else {
                                if dictarray.count == 0 {
                                    if nexttimeinstead == false {
                                        nexttimeinstead = true
                                        ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME = "word"
                                        ADD_BONUS_LOOP_COMMANDS_FOR_NEXT_TIME = bitb.components(separatedBy: ", ")
                                        ADD_BONUS_PREPEND_FOR_NEXT_TIME = prependEachWord
                                        ADD_BONUS_APPEND_FOR_NEXT_TIME = appendEachWord
                                        ADD_BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME = delayoneprepend
                                        saveAdditionalTextForNextTime = true
                                    }
                                    else {
                                        ADD_BONUS_TEXT_FOR_NEXT_TIME += String(WORD_COMMAND_DELIMITER) + bitb + String(WORD_COMMAND_DELIMITER)
                                    }
                                }
                                else {
                                    
                                    if saveAdditionalTextForNextTime == false {
                                        var toadd = LaTeXWord(extraCommandAliases: bitb.components(separatedBy: ", "), prependEachWord: "", appendEachWord: "")
                                        
                                        if toadd.characters.count > 1 {
                                            if toadd.characters.last == " " {
                                                toadd = toadd.substring(to: toadd.length - 1)
                                            }
                                        }
                                        stringtoreturn += toadd
                                    }
                                    else {
                                        var toadd = LaTeXWord(extraCommandAliases: bitb.components(separatedBy: ", "), prependEachWord: "", appendEachWord: "")
                                        
                                        if toadd.characters.count > 1 {
                                            if toadd.characters.last == " " {
                                                toadd = toadd.substring(to: toadd.length - 1)
                                            }
                                        }
                                        ADD_BONUS_TEXT_FOR_NEXT_TIME += toadd
                                    }
                                    //stringtoreturn += toadd
                                    
//                                    loopRecord.append(toadd)
//                                    loopNumber += 1
                                }
                            }
                            normaltext = !normaltext
                        }
                        normaltext = true
                    } else {
                        if dictarray.count == 0 {
                            if nexttimeinstead == false {
                                nexttimeinstead = true
                                ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME = "multi"
                                ADD_BONUS_LOOP_COMMANDS_FOR_NEXT_TIME = bit.components(separatedBy: ", ")
                                ADD_BONUS_PREPEND_FOR_NEXT_TIME = prependEachWord
                                ADD_BONUS_APPEND_FOR_NEXT_TIME = appendEachWord
                                ADD_BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME = delayoneprepend
                                saveAdditionalTextForNextTime = true
                            }
                            else {
                                ADD_BONUS_TEXT_FOR_NEXT_TIME += String(LOOP_COMMAND_DELIMITER) + bit + String(LOOP_COMMAND_DELIMITER)
                            }
                        }
                        else {
                            breakOutOfLoop = false
                            
                            if saveAdditionalTextForNextTime == false {
                                var toadd = LaTeXLoop(extraCommandAliases: bit.components(separatedBy: ", "), prependEachWord: prependEachWord, appendEachWord: appendEachWord, delayoneprepend: delayoneprepend)
                                
                                if toadd.characters.count > 1 {
                                    if toadd.characters.last == " " {
                                        toadd = toadd.substring(to: toadd.length - 1)
                                    }
                                }
                                
                                stringtoreturn += toadd
                            }
                            else {
                                var toadd = LaTeXLoop(extraCommandAliases: bit.components(separatedBy: ", "), prependEachWord: prependEachWord, appendEachWord: appendEachWord, delayoneprepend: delayoneprepend)
                                
                                if toadd.characters.count > 1 {
                                    if toadd.characters.last == " " {
                                        toadd = toadd.substring(to: toadd.length - 1)
                                    }
                                }
                                
                                ADD_BONUS_TEXT_FOR_NEXT_TIME += toadd
                            }
                            //stringtoreturn += toadd
                            
//                            loopRecord.append(toadd)
//                            loopNumber += 1
                        }
                    }
                    normaltext = !normaltext
                }
            if stringtoreturn.characters.count > 0 {
                let lastchar = String(stringtoreturn.characters.last!)
                if (stringtoreturn.index(of: POINTER_DELIMITER) == nil && lastchar != " " && lastchar != NEW_LINE_DELIMITER) //if no pointer or ending space or new line, add a space
                {
                    stringtoreturn += " "
                }
            }
            
//            for loopno in 1..<loopNumber {
//                if loopNumber < 10 {
//                    stringtoreturn = stringtoreturn.replacingOccurrences(of: REPEATER_DELIMITER + String(loopno), with: loopRecord[loopno - 1])
//                }
//            }
            
            return stringtoreturn
        }
        
        func LaTeXLoop(extraCommandAliases: [String], prependEachWord: String, appendEachWord: String, delayoneprepend: Bool) -> String {
            var stringtoreturn = ""
            var delayprepend = delayoneprepend
            
            
            while (dictarray.count > 0 && breakOutOfLoop == false) {
                if delayprepend == false {
                    stringtoreturn += LaTeXWord(extraCommandAliases: extraCommandAliases, prependEachWord: prependEachWord, appendEachWord: appendEachWord)
                }
                else {
                    stringtoreturn += LaTeXWord(extraCommandAliases: extraCommandAliases, prependEachWord: "", appendEachWord: appendEachWord)
                    delayprepend = false
                }
            }
            breakOutOfLoop = false
            
            
            return stringtoreturn
        }
        
        func LaTeXWord(extraCommandAliases: [String], prependEachWord: String, appendEachWord: String) -> String {
            
            if (dictarray.count > 0) {
                var word = dictarray.removeFirst()
                
                while word == "" {
                    word = dictarray.removeFirst()
                }
                
                if word == "break" {
                    breakOutOfLoop = true
                    return ""
                }
                
                if word == "verbatimTextPlaceholder" {
                    return ARRAY_OF_VERBATIM_TEXT.removeFirst()
                }
                
                for command in extraCommandAliases {
                    let split = command.components(separatedBy: ":")
                    if split.count > 1 {
                        let aliases = split[0].components(separatedBy: "|")
                        if (aliases.contains(word)) {
                            var toreturn = ""
                            for subcommandsword in split[1].components(separatedBy: " ") {
                                if subcommandsword != "" {
                                    dictarray.insert(subcommandsword, at: 0)
                                    toreturn += LaTeXWord(extraCommandAliases: [String](),prependEachWord: "", appendEachWord: "")
                                }
                            }
                            return toreturn
                        }
                    }
                }
                
                for command in builtInCommandsList {
                    if (command[0].components(separatedBy: "|").contains(word)) {
                        
                        let thecommand = Array<String>(command.dropFirst()).joined(separator: ":")
                        
                        return prependEachWord + interpretCommand(command: thecommand) + appendEachWord
                    }
                }
                
                return prependEachWord + word + appendEachWord + " "
            }
            return ""
        }
        
        var returnstring = ""
        saveAdditionalTextForNextTime = false
        
        resetAddBonuses()
        
        
        //All of the following is to handle 'bonus' stuff, that is, stuff saved between dictations
        if (dictarray.count > 1) {
            while (BONUS_LOOP_TYPE_FOR_NEXT_TIME.count > 0 && ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME == "none") {
                let bonustext = BONUS_TEXT_FOR_NEXT_TIME[0]
                let bonuslooptype = BONUS_LOOP_TYPE_FOR_NEXT_TIME[0]
                let bonusloopcommands = BONUS_LOOP_COMMANDS_FOR_NEXT_TIME[0]
                let bonusappend = BONUS_APPEND_FOR_NEXT_TIME[0]
                let bonusprepend = BONUS_PREPEND_FOR_NEXT_TIME[0]
                let bonusdelay = BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0]
                
                if dictarray.count > 0 && dictarray[0] == "break" {
                        removeFirstBonus()
                        
                        resetAddBonuses()
                        returnstring += interpretCommand(command: bonustext)
                        addBonuses()
                }
                else {
                    if (bonuslooptype == "multi") {
                        resetAddBonuses()
                        
                        returnstring += LaTeXLoop(extraCommandAliases: bonusloopcommands, prependEachWord: bonusprepend, appendEachWord: bonusappend, delayoneprepend: bonusdelay)
                        
                        BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0] = false
                        
                        if !addBonuses() {
                            removeFirstBonus()
                            
                            resetAddBonuses()
                            returnstring += interpretCommand(command: bonustext)
                            addBonuses()
                        }
                    }
                    else {
                        resetAddBonuses()
                        
                        returnstring += LaTeXWord(extraCommandAliases: bonusloopcommands, prependEachWord: "", appendEachWord: "")
                        
                        BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0] = false
                        
                        if !addBonuses() {
                            removeFirstBonus()
                            
                            resetAddBonuses()
                            returnstring += interpretCommand(command: bonustext)
                            addBonuses()
                        }
                    }
                }
                
                
            }
            if BONUS_LOOP_TYPE_FOR_NEXT_TIME.count == 0 {
                resetAddBonuses()
                returnstring += LaTeXLoop(extraCommandAliases: [String](), prependEachWord: "", appendEachWord: "", delayoneprepend: false)
                addBonuses()
            }
        }
        else if (dictarray.count == 1) {
            if (BONUS_LOOP_TYPE_FOR_NEXT_TIME.count > 0) {
                var firstloop = true
                while (BONUS_LOOP_TYPE_FOR_NEXT_TIME.count > 0 && ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME == "none" && (firstloop == true || BONUS_LOOP_TYPE_FOR_NEXT_TIME[0] == "word")) {
                    firstloop = false
                    
                    let bonustext = BONUS_TEXT_FOR_NEXT_TIME[0]
                    let bonuslooptype = BONUS_LOOP_TYPE_FOR_NEXT_TIME[0]
                    let bonusloopcommands = BONUS_LOOP_COMMANDS_FOR_NEXT_TIME[0]
                    let bonusappend = BONUS_APPEND_FOR_NEXT_TIME[0]
                    let bonusprepend = BONUS_PREPEND_FOR_NEXT_TIME[0]
                    let bonusdelay = BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0]
                    
                    if dictarray[0] == "break" {
                        removeFirstBonus()
                        
                        resetAddBonuses()
                        returnstring += interpretCommand(command: bonustext)
                        addBonuses()
                        
                    }
                    else {
                        if (bonuslooptype == "multi") {
                            resetAddBonuses()
                            
                            returnstring += LaTeXLoop(extraCommandAliases: bonusloopcommands, prependEachWord: bonusprepend, appendEachWord: bonusappend, delayoneprepend: bonusdelay)
                            
                            BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0] = false
                            
                            addBonuses()
                        }
                        else {
                            resetAddBonuses()
                            
                            returnstring += LaTeXWord(extraCommandAliases: bonusloopcommands, prependEachWord: "", appendEachWord: "")
                            
                            BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME[0] = false
                            if !addBonuses() {
                                removeFirstBonus()
                                
                                resetAddBonuses()
                                returnstring += interpretCommand(command: bonustext)
                                addBonuses()
                            }
                        }
                    }
                    
                    
                }
            }
            if BONUS_LOOP_TYPE_FOR_NEXT_TIME.count == 0 {
                resetAddBonuses()
                returnstring += LaTeXLoop(extraCommandAliases: [String](), prependEachWord: "", appendEachWord: "", delayoneprepend: false)
                addBonuses()
            }
        }
        
        returnstring = returnstring.replacingOccurrences(of: NEW_LINE_DELIMITER, with: "\n")
        
        
        //returnstring += textToPrintVerbatim + textToPrintAfterVerbatim
        
        if returnstring.index(of: POINTER_DELIMITER) != nil {
            gobackwithcursor = Int!(returnstring.distance(from: returnstring.index(of: POINTER_DELIMITER)!, to: returnstring.endIndex)) - returnstring.components(separatedBy: POINTER_DELIMITER).count + 1 //subtract off 1 for each pointer
            returnstring = returnstring.replacingOccurrences(of: POINTER_DELIMITER, with: "")
        }
        return returnstring
        
    }
}

func resetAddBonuses() {
    ADD_BONUS_TEXT_FOR_NEXT_TIME = ""
    ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME = "none"
    ADD_BONUS_LOOP_COMMANDS_FOR_NEXT_TIME = [String]()
    ADD_BONUS_APPEND_FOR_NEXT_TIME = ""
    ADD_BONUS_PREPEND_FOR_NEXT_TIME = ""
    ADD_BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME = false
}

func removeFirstBonus() {
    BONUS_LOOP_TYPE_FOR_NEXT_TIME.removeFirst()
    BONUS_LOOP_COMMANDS_FOR_NEXT_TIME.removeFirst()
    BONUS_APPEND_FOR_NEXT_TIME.removeFirst()
    BONUS_PREPEND_FOR_NEXT_TIME.removeFirst()
    BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME.removeFirst()
    BONUS_TEXT_FOR_NEXT_TIME.removeFirst()
}

@discardableResult func addBonuses() -> Bool {
    if ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME != "none" {
        BONUS_TEXT_FOR_NEXT_TIME.insert(ADD_BONUS_TEXT_FOR_NEXT_TIME, at: 0)
        BONUS_LOOP_TYPE_FOR_NEXT_TIME.insert(ADD_BONUS_LOOP_TYPE_FOR_NEXT_TIME, at: 0)
        BONUS_LOOP_COMMANDS_FOR_NEXT_TIME.insert(ADD_BONUS_LOOP_COMMANDS_FOR_NEXT_TIME, at: 0)
        BONUS_APPEND_FOR_NEXT_TIME.insert(ADD_BONUS_APPEND_FOR_NEXT_TIME, at: 0)
        BONUS_PREPEND_FOR_NEXT_TIME.insert(ADD_BONUS_PREPEND_FOR_NEXT_TIME, at: 0)
        BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME.insert(ADD_BONUS_DELAY_ONE_PREPEND_FOR_NEXT_TIME, at: 0)
        
        return true
    }
    
    return false
}
