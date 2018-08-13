import Foundation

func writeXMLVocabToFile(vocablist: [[String]]) { //items are [word, spokenalias]
        
        var textforfile = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n<key>Version</key>\n<string>3.0/1</string>\n<key>Words</key>\n<array>"
    
        for item in vocablist {
            textforfile += "<dict>\n<key>EngineFlags</key>\n<integer>1</integer>\n<key>Flags</key>\n<string>1</string>\n<key>Sense</key>\n<string></string>\n<key>Source</key>\n<string>User</string>\n<key>Spoken</key>\n<string>" + item[1] + "</string>\n<key>Written</key>\n<string>" + item[0] + "</string>\n</dict>\n"
        }
        
        textforfile += "</array>\n</dict>\n</plist>\n"
        
        writeFile(filename: "exportedvocab.xml", stringToWrite: textforfile)
}

func writeXMLCommandsToFile(commandslist: [String], language: String, bundle: String) {
    
    //tell application \"Dragon\" to keystroke
    
    //let applescriptString = "#!/bin/bash\nosascript -e \"if application \\\\\"SpeakLaTeX\\\\\" is running then\ntell application \\\\\"SpeakLaTeX\\\\\" to interpret text (\\\\\"oscar ${varDictation}\\\\\")\nelse\nset theClipboard to (the clipboard as text)\nset the clipboard to (\\\\\"oscar ${varDictation}\\\\\")\ntell application \\\\\"System Events\\\\\" to keystroke \\\\\"v\\\\\" using command down\ndelay 0.02\nset the clipboard to theClipboard\nend if\""
    
    //
    
    //let applescriptString = "set _dictateApp to (name of current application)\non srhandler(vars)\nif application \"SpeakLaTeX\" is running then\nset theClipboard to (the clipboard as text)\ntell application \"SpeakLaTeX\"\nset the clipboard to (interpret text (\"%word% \" \\u2600 varDiddly of vars))\nend tell\ntell application \"System Events\" to keystroke \"v\" using command down\ndelay 0.02\nset the clipboard to theClipboard\nelse\nset theClipboard to (the clipboard as text)\nset the clipboard to (\"%word% \" \\u2600 varDiddly of vars)\ntell application \"System Events\" to keystroke \"v\" using command down\ndelay 0.02\nset the clipboard to theClipboard\nend if\nend srhandler"
    
    let applescriptString = "#!/bin/bash\nosascript -e \"if application \\\\\"SpeakLaTeX\\\\\" is running then\ntell application \\\\\"SpeakLaTeX\\\\\" to interpret text (\\\\\"%word% ${varDictation}\\\\\")\nelse\nset theClipboard to (the clipboard as text)\nset the clipboard to (\\\\\" %word% ${varDictation}\\\\\")\ntell application \\\\\"System Events\\\\\" to keystroke \\\\\"v\\\\\" using command down\ndelay 0.02\nset the clipboard to theClipboard\nend if\""
    
    let randomseven = arc4random_uniform(10000000)
    let randomsevenint: Int = Int(randomseven)
    
    
    
    let noMoreThan = 1000;
    
    let cutDownToSizeCommandsLists = stride(from: 0, to: commandslist.count, by: noMoreThan).map {
        Array(commandslist[$0..<min($0 + noMoreThan, commandslist.count)])
    } //no more than noMoreThan in each list
    
    var index = 0;
    
        //                let myAppleScript = "tell application \"Dragon\" to get command \"" + word + " /!Diddly!/\" exists"
        //                var error: NSDictionary?
        //                if let scriptObject = NSAppleScript(source: myAppleScript) {
        //                    if let scriptResult: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
        //                        &error) {
        //
        //                        if scriptResult.stringValue == "false" {
        //
        //                        lastWord = word
        //                        wordList.append(word)
        //                        appleScriptToAddCommands += "tell application \"Dragon\" to make command with properties {active:true, name:\"" + word + " /!Diddly!/\", command type:AppleScript, content:\"set _dictateApp to (name of current application)\non srhandler(vars)\nif application \\\"SpeakLaTeX\\\" is running then\nset theClipboard to (the clipboard as text)\ntell application \\\"SpeakLaTeX\\\" to interpret text (\\\"" + word + " \\\" & varDiddly of vars)\nelse\nset theClipboard to (the clipboard as text)\nset the clipboard to (\\\"" + word + " \\\" & varDiddly of vars)\ntell application \\\"System Events\\\" to keystroke \\\"v\\\" using command down\ndelay 0.02\nset the clipboard to theClipboard\nend if\nend srhandler\"}\n" + "delay 0.8\n"
        //                        }
        //                    } else if (error != nil) {
        //                        print("error!")
        //                    }
        //                }
    
    for cutDownCommands in cutDownToSizeCommandsLists {
        
        let resultingSplitApplescriptString = applescriptString.components(separatedBy: "%word%")
        
        // + String(randomsevenint) + String(10000 + index) +
        
        var textforfile = "<?xml version=\"1.0\"?>\n<!DOCTYPE database SYSTEM \"file:///System/Library/DTDs/CoreData.dtd\">\n<database>\n    <databaseInfo>\n        <version>134481920</version>\n        <UUID>4DF19FAD-AAB6-4140-8895-" + String(randomsevenint) + String(10000 + index) + "</UUID>\n        <nextObjectID>104</nextObjectID>\n        <metadata>\n            <plist version=\"1.0\">\n                <dict>\n                    <key>NSPersistenceFrameworkVersion</key>\n                    <integer>641</integer>\n                    <key>NSStoreModelVersionHashes</key>\n                    <dict>\n                        <key>action</key>\n                        <data>\nGl79yicU/qMmmjW+02T6r/N/3wY/MXt1/ETG6BgiQvk=\n</data>\n                        <key>command</key>\n                        <data>\nCVWAj3pI3IEwfonouBAnn1vC3gKGuyjFjuvCz8mLl+M=\n</data>\n                        <key>location</key>\n                        <data>\nl1GW8zsQs6xToCTE303HdInkm0pvem69Qmej6Ixq3k4=\n</data>\n                        <key>trigger</key>\n                        <data>\nkWwewq0GT8KPB4ELML1wT0S2IYIZ5+/6CI0GsK9LDns=\n</data>\n                    </dict>\n                    <key>NSStoreModelVersionHashesVersion</key>\n                    <integer>3</integer>\n                    <key>NSStoreModelVersionIdentifiers</key>\n                    <array>\n                        <string></string>\n                    </array>\n                </dict>\n            </plist>\n        </metadata>\n    </databaseInfo>"
        
        var commandidnum = 102;
        
        
        for item in cutDownCommands {
            textforfile += "\n" + xmlcommand(commandword : item, id :  noMoreThan * index + commandidnum, commandid : String(11) +  String(randomsevenint + noMoreThan * index + commandidnum), splitApplescriptString: resultingSplitApplescriptString, language: language, bundle: bundle)
            commandidnum += 3;
        }
        
        textforfile += "\n</database>"
        
        writeFile(filename: "SpeakLaTeX_commands.commandstext", stringToWrite: textforfile)
        
        index += 1
    }
}

func xmlcommand(commandword : String, id : Int, commandid : String, splitApplescriptString : [String], language: String, bundle: String) -> String {
    
    if bundle == "" {
        return "<object type=\"TRIGGER\" id=\"z" + String(id) + "\">\n        <attribute name=\"string\" type=\"string\">" + commandword + " /!Dictation!/</attribute>\n        <attribute name=\"spokenlanguage\" type=\"string\">" + language + "</attribute>\n        <attribute name=\"isuser\" type=\"bool\">1</attribute>\n        <attribute name=\"desc\" type=\"string\">Description (optional)</attribute>\n        <relationship name=\"command\" type=\"1/1\" destination=\"COMMAND\" idrefs=\"z" + String(id + 1) + "\"></relationship>\n        <relationship name=\"currentcommand\" type=\"1/1\" destination=\"COMMAND\"></relationship>\n    </object>\n    <object type=\"COMMAND\" id=\"z" + String(id + 1) + "\">\n        <attribute name=\"version\" type=\"int32\">1</attribute>\n        <attribute name=\"vendor\" type=\"string\">speaklatex</attribute>\n        <attribute name=\"type\" type=\"string\">ShellScript</attribute>\n        <attribute name=\"spokenlanguage\" type=\"string\">" + language + "</attribute>\n        <attribute name=\"oslanguage\" type=\"string\">en_US</attribute>\n        <attribute name=\"isspelling\" type=\"bool\">0</attribute>\n        <attribute name=\"issleep\" type=\"bool\">0</attribute>\n        <attribute name=\"isdictation\" type=\"bool\">0</attribute>\n        <attribute name=\"iscorrection\" type=\"bool\">0</attribute>\n        <attribute name=\"iscommand\" type=\"bool\">1</attribute>\n        <attribute name=\"engineid\" type=\"int32\">-1</attribute>\n        <attribute name=\"display\" type=\"bool\">1</attribute>\n        <attribute name=\"commandid\" type=\"int32\">" + commandid + "</attribute>\n        <attribute name=\"appversion\" type=\"int32\">0</attribute>\n        <attribute name=\"active\" type=\"bool\">1</attribute>\n        <relationship name=\"currentaction\" type=\"1/1\" destination=\"ACTION\"></relationship>\n        <relationship name=\"currenttrigger\" type=\"1/1\" destination=\"TRIGGER\"></relationship>\n        <relationship name=\"location\" type=\"1/1\" destination=\"LOCATION\"></relationship>\n        <relationship name=\"action\" type=\"0/0\" destination=\"ACTION\" idrefs=\"z" + String(id + 2) + "\"></relationship>\n        <relationship name=\"trigger\" type=\"1/0\" destination=\"TRIGGER\" idrefs=\"z" + String(id) + "\"></relationship>\n    </object>\n    <object type=\"ACTION\" id=\"z" + String(id + 2) + "\">\n        <attribute name=\"text\" type=\"string\">" + splitApplescriptString.joined(separator: commandword) + "</attribute>\n        <attribute name=\"oslanguage\" type=\"string\">en_US</attribute>\n        <attribute name=\"isuser\" type=\"bool\">1</attribute>\n        <relationship name=\"command\" type=\"1/1\" destination=\"COMMAND\" idrefs=\"z" + String(id + 1) + "\"></relationship>\n        <relationship name=\"currentcommand\" type=\"1/1\" destination=\"COMMAND\"></relationship>\n    </object>"
    }
    else {
        return "<object type=\"TRIGGER\" id=\"z" + String(id) + "\">\n        <attribute name=\"string\" type=\"string\">" + commandword + " /!Dictation!/</attribute>\n        <attribute name=\"spokenlanguage\" type=\"string\">" + language + "</attribute>\n        <attribute name=\"isuser\" type=\"bool\">1</attribute>\n        <attribute name=\"desc\" type=\"string\">Description (optional)</attribute>\n        <relationship name=\"command\" type=\"1/1\" destination=\"COMMAND\" idrefs=\"z" + String(id + 1) + "\"></relationship>\n        <relationship name=\"currentcommand\" type=\"1/1\" destination=\"COMMAND\"></relationship>\n    </object>\n    <object type=\"COMMAND\" id=\"z" + String(id + 1) + "\">\n        <attribute name=\"version\" type=\"int32\">1</attribute>\n        <attribute name=\"vendor\" type=\"string\">speaklatex</attribute>\n        <attribute name=\"type\" type=\"string\">ShellScript</attribute>\n        <attribute name=\"spokenlanguage\" type=\"string\">" + language + "</attribute>\n        <attribute name=\"oslanguage\" type=\"string\">en_US</attribute>\n        <attribute name=\"isspelling\" type=\"bool\">0</attribute>\n        <attribute name=\"issleep\" type=\"bool\">0</attribute>\n        <attribute name=\"isdictation\" type=\"bool\">0</attribute>\n        <attribute name=\"iscorrection\" type=\"bool\">0</attribute>\n        <attribute name=\"iscommand\" type=\"bool\">1</attribute>\n        <attribute name=\"engineid\" type=\"int32\">-1</attribute>\n        <attribute name=\"display\" type=\"bool\">1</attribute>\n        <attribute name=\"commandid\" type=\"int32\">" + commandid + "</attribute>\n        <attribute name=\"appversion\" type=\"int32\">0</attribute>\n        <attribute name=\"appbundle\" type=\"string\">" + bundle + "</attribute>\n        <attribute name=\"active\" type=\"bool\">1</attribute>\n        <relationship name=\"currentaction\" type=\"1/1\" destination=\"ACTION\"></relationship>\n        <relationship name=\"currenttrigger\" type=\"1/1\" destination=\"TRIGGER\"></relationship>\n        <relationship name=\"location\" type=\"1/1\" destination=\"LOCATION\"></relationship>\n        <relationship name=\"action\" type=\"0/0\" destination=\"ACTION\" idrefs=\"z" + String(id + 2) + "\"></relationship>\n        <relationship name=\"trigger\" type=\"1/0\" destination=\"TRIGGER\" idrefs=\"z" + String(id) + "\"></relationship>\n    </object>\n    <object type=\"ACTION\" id=\"z" + String(id + 2) + "\">\n        <attribute name=\"text\" type=\"string\">" + splitApplescriptString.joined(separator: commandword) + "</attribute>\n        <attribute name=\"oslanguage\" type=\"string\">en_US</attribute>\n        <attribute name=\"isuser\" type=\"bool\">1</attribute>\n        <relationship name=\"command\" type=\"1/1\" destination=\"COMMAND\" idrefs=\"z" + String(id + 1) + "\"></relationship>\n        <relationship name=\"currentcommand\" type=\"1/1\" destination=\"COMMAND\"></relationship>\n    </object>"
    }
}





//"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"
