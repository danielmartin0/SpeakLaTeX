import Cocoa


class StatusMenuController: NSObject, NSMenuDelegate {
    
    var recognisedCommandsWindow: TextWindow!
    var regexWindow: TextWindow!
    var phoneticWindow: PhoneticWindowController!
    var AboutSpeakLaTeXWindow: AboutSpeakLaTeXWindowController!
    var HelpMainWindow: HelpWindowController!
    var HelpSyntaxWindow: HelpWindowController!
    var PleaseWaitWindow: PleaseWaitController!
    var alertup = false
    
    var button: NSStatusBarButton?
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: "statusIconEnabled")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        
        statusMenu.delegate = self
        
        button = statusItem.button
        button!.target = self
        button!.action = #selector(self.statusBarButtonClicked(_:))
        button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        recognisedCommandsWindow = TextWindow()
        recognisedCommandsWindow.defaultsKey = "commands"
        //recognisedCommandsWindow.otherwiseDefaultsVariable = DEFAULT_COMMANDS
        recognisedCommandsWindow.title = "SpeakLaTeX: Stored Commands"
        
        regexWindow = TextWindow()
        regexWindow.defaultsKey = "regex"
        //regexWindow.otherwiseDefaultsVariable = DEFAULT_REGEX
        regexWindow.title = "SpeakLaTeX: Stored Regex Replacements"
        
        phoneticWindow = PhoneticWindowController()
        phoneticWindow.window = NSWindow(contentRect: NSMakeRect(0, 0, 780, 160), styleMask: [.titled, .closable, .miniaturizable], backing: NSBackingStoreType.buffered, defer: false)
        phoneticWindow.window?.center()
        
        AboutSpeakLaTeXWindow = AboutSpeakLaTeXWindowController()
        HelpMainWindow = HelpWindowController()
        HelpSyntaxWindow = HelpWindowController()
        PleaseWaitWindow = PleaseWaitController()
        
        
        
        HelpMainWindow.myTitle = "SpeakLaTeX User Guide"
        
        HelpMainWindow.myString = USER_GUIDE_TEXT
        
        
        
        HelpSyntaxWindow.myTitle = "SpeakLaTeX Commands Syntax Reference"
        
        HelpSyntaxWindow.myString = SYNTAX_REFERENCE_TEXT
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func statusBarButtonClicked(_ sender: AnyObject?) {
        if AboutSpeakLaTeXWindow.beenopened == true {
            if AboutSpeakLaTeXWindow.window?.isVisible == true {
                AboutSpeakLaTeXWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        if HelpMainWindow.beenopened == true {
            if HelpMainWindow.window?.isVisible == true {
                HelpMainWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        if HelpSyntaxWindow.beenopened == true {
            if HelpSyntaxWindow.window?.isVisible == true {
                HelpSyntaxWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        if phoneticWindow.beenopened == true {
            if phoneticWindow.window?.isVisible == true {
                phoneticWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        if regexWindow.beenopened == true {
            if regexWindow.window?.isVisible == true {
                regexWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        if recognisedCommandsWindow.beenopened == true {
            if recognisedCommandsWindow.window?.isVisible == true {
                recognisedCommandsWindow.window?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        
        let event = NSApp.currentEvent!
        
        if event.type == NSEventType.rightMouseUp {
            if SPEAKLATEX_ACTIVE == true {
                disableSpeakLaTeX()
            }
            else {
                enableSpeakLaTeX()
            }
        } else {
            if alertup == false {
                //statusItem.menu = statusMenu
                
                if SPEAKLATEX_ACTIVE == true {
                    statusMenu.item(withTag: 2)?.isEnabled = true
                }
                else {
                    statusMenu.item(withTag: 2)?.isEnabled = false
                }
                
                if OSXDICTON == true {
                    statusMenu.item(withTag: 2)?.title = "Disable macOS Dictation"
                }
                else {
                    statusMenu.item(withTag: 2)?.title = "Enable macOS Dictation"
                }
                
                //statusItem.menu = nil // This is critical, otherwise clicks won't be processed again
                
                //NSApp.window
                statusItem.popUpMenu(statusMenu)
            }
        }
        
    }
    
    
    
    @IBAction func toggleAssistant(_ sender: NSMenuItem) {
        if OSXDICTON == true {
            appDelegate.MacOSDictStopListening()
            OSXDICTON = false
        }
        else {
            appDelegate.MacOSDictResumeListening()
            OSXDICTON = true
        }
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func recognisedCommandsClicked(_ sender: NSMenuItem) {
        if (recognisedCommandsWindow.beenopened == false || recognisedCommandsWindow.window?.isVisible == false) {
            recognisedCommandsWindow.openWindow()
        }
    }
    
    @IBAction func regexClicked(_ sender: NSMenuItem) {
        if (regexWindow.beenopened == false || regexWindow.window?.isVisible == false) {
        regexWindow.openWindow()
        }
    }
    
    @IBOutlet var ExportDetails: NSView!
    
    @IBOutlet var RegionPopUp: NSPopUpButton!
    
    @IBOutlet var ContextPopUp: NSPopUpButton!
    
    @IBAction func makeXMLCommands(_ sender: NSMenuItem) {
        
        alertup = true
        
        let msg = NSAlert()
        msg.addButton(withTitle: "Proceed")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = "Export Commands for Dragon for Mac v6"
        msg.informativeText = "This function will produce a commands file that can be imported into Dragon v6. The file will contain one 'wildcard' Dragon command for every command word in the SpeakLaTeX commands. (A command word is a word before the first '|' on a given line in the SpeakLaTeX stored commands.) \n\nThe purpose the wildcard commands is to tell Dragon to send dictated text to SpeakLaTeX if the dictation starts with a command word, unless SpeakLaTeX is disabled, in which case the dictated text will be pasted verbatim.\n\nBefore importing these commands to Dragon, it is recommended you backup your current Dragon commands.\n\nFinally, please select your region and the app for which the commands will be active. If the desired app is not shown, click cancel, open the app, and try again."
        
        Bundle.main.loadNibNamed("ExportDetails", owner:self, topLevelObjects:nil)
        
        
        let languagelist = ["United Kingdom","United States","Singapore","New Zealand","India","Canada","Australia"]
        var usedlanguagelist = languagelist
        
        if defaults.object(forKey: "spokenlanguage") != nil {
            usedlanguagelist.insert(languagelist[defaults.integer(forKey: "spokenlanguage")], at: 0)
            usedlanguagelist.remove(at: (defaults.integer(forKey: "spokenlanguage")) + 1)
        }
        
        for eachlanguage in usedlanguagelist {
            RegionPopUp.addItem(withTitle: eachlanguage)
        }
        
        
        let workspace = NSWorkspace.shared()
        let allapplications = workspace.runningApplications
        let regularapplications = allapplications.filter({$0.activationPolicy == .regular})
        ContextPopUp.addItem(withTitle: "Global")
        for app in regularapplications {
            ContextPopUp.addItem(withTitle: String(app.localizedName!))
        }
        
        
        msg.accessoryView = ExportDetails
        
        
        let response: NSModalResponse = msg.runModal()
        
        if (response == NSAlertFirstButtonReturn) {
            
            let choice = RegionPopUp.indexOfSelectedItem
            let choicelanguage = usedlanguagelist[choice]
            let choicelanguageid = Int(languagelist.index(of: choicelanguage)!)
            
            var language = "en_UK"
            switch(choicelanguageid) {
            case 0:
                language = "en_GB"
                break
            case 1:
                language = "en_US"
                break
            case 2:
                language = "en_SG"
                break
            case 3:
                language = "en_AU"
                break
            case 4:
                language = "en_IN"
                break
            case 5:
                language = "en_CA"
                break
            case 6:
                language = "en_AU"
                break
            default:
                language = "en_GB"
            }
            
            defaults.set(choicelanguageid, forKey: "spokenlanguage")
            
            var context = ""
            if ContextPopUp.indexOfSelectedItem > 0 {
                context = (regularapplications[ContextPopUp.indexOfSelectedItem - 1].bundleIdentifier)!
            }
            
            var commandsToWrite = [String]()
            
            for item in appDelegate.MainRecognisedWordHandler.wordsToTriggerDragonSpeech {
                commandsToWrite.append(item)
            }
            
//            for item in appDelegate.MainRecognisedWordHandler.wordsToTriggerDragonSpeech {
//                let myAppleScript = "tell application \"Dragon\" to get command \"" + item + " /!Dictation!/\" exists"
//                var error: NSDictionary?
//                if let scriptObject = NSAppleScript(source: myAppleScript) {
//                    if let scriptResult: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
//                        if scriptResult.stringValue == "false" {
//                            commandsToWrite.append(item)
//                        }
//                    } else if (error != nil) {
//                        print("error!")
//                    }
//                }
//            }
            
            commandsToWrite = commandsToWrite.filter{$0 != "size"}
            commandsToWrite = commandsToWrite.filter{$0 != "empty"}
            commandsToWrite = commandsToWrite.filter{$0 != "hash"}
            
            print(commandsToWrite)
            
            commandsToWrite.sort(by: {$0 < $1})
            
            if commandsToWrite.count > 0 {
                
                writeXMLCommandsToFile(commandslist: commandsToWrite, language: language, bundle: context)
                
                let msg4 = NSAlert()
                msg4.addButton(withTitle: "OK")
                msg4.messageText = "Commands saved to desktop as SpeakLaTeX_commands.commandstext."
                //msg4.informativeText = "List of command words exported:\n" + commandsToWrite.joined(separator: ", ")
                //msg4.accessoryView = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 0))
                
                msg4.runModal()
            }
            else {
                let msg4 = NSAlert()
                msg4.addButton(withTitle: "OK")
                msg4.messageText = "No commands were exported."
                
                msg4.runModal()
            }
        }
        
        
        
        alertup = false
    }
    
//    @IBAction func makeXMLVocab(_ sender: NSMenuItem) {
//        let vocabToWrite = appDelegate.MainRecognisedWordHandler.vocabList
//        
//        writeXMLVocabToFile(vocablist: vocabToWrite)
    //    }
//    @IBAction func addCommandsByApplescript(_ sender: NSMenuItem) {
//        
//        alertup = true
//        
//        let maxToAdd = 50
//        var commandsToWrite = appDelegate.MainRecognisedWordHandler.wordsToTriggerSpeech
//        
//        commandsToWrite = commandsToWrite.filter{$0 != "comma"}
//        
//        
//        
//        var dummyAppleScript = "tell application \"Dragon\" to make command with properties {name: \"dummycommandname\"}"
//        
//        var error1: NSDictionary?
//        if let scriptObject1 = NSAppleScript(source: dummyAppleScript) {
//            if let scriptResult: NSAppleEventDescriptor = scriptObject1.executeAndReturnError(
//                &error1) {
//                print("good")
//            } else if (error1 != nil) {
//                print(error1)
//            }
//        }
//        
//        var lastWord = ""
//        var wordList: [String]! = []
//        var appleScriptToAddCommands = ""
//        for word in commandsToWrite {
//            if wordList.count < maxToAdd {
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
//            }
//        }
//        
//        dummyAppleScript = "tell application \"Dragon\" to delete command \"dummycommandname\""
//        
//        var error2: NSDictionary?
//        if let scriptObject2 = NSAppleScript(source: dummyAppleScript) {
//            if let scriptResult: NSAppleEventDescriptor = scriptObject2.executeAndReturnError(
//                &error2) {
//                print("good")
//            } else if (error2 != nil) {
//                print(error2)
//            }
//        }
//        
//        appleScriptToAddCommands += "tell application \"Dragon\" to reveal command \"About this Application\""
//        
//        print(appleScriptToAddCommands)
//        
//        if lastWord != "" {
//            let msg = NSAlert()
//            msg.addButton(withTitle: "Proceed")      // 1st button
//            msg.addButton(withTitle: "Cancel")  // 2nd button
//            msg.messageText = "Warning!"
//            msg.informativeText = "This function will directly add SpeakLaTeX commands to Dragon Professional Individual for Mac v6. No more than " + String(maxToAdd) + " commands will be added at once.\n\nBefore proceeding, backup your commands. Then, make sure Dragon v6 is fully loaded with the microphone off.\n\nThe following words will be added:\n" + wordList.joined(separator: ", ")
//            
//                let response: NSModalResponse = msg.runModal()
//                
//                if (response == NSAlertFirstButtonReturn) {
//                    
//                    //                    let msg3 = NSAlert()
//                    //                    msg3.messageText = "Please wait..."
//                    //                    msg3.informativeText = "Aborting early will leave Dragon with commands that are not yet compiled."
//                    //                    msg3.addButton(withTitle: "Stop anyway")
//                    //
//                    //                    msg3.runModal()
//                    
//                    
//                    PleaseWaitWindow.window?.makeKeyAndOrderFront(nil)
//                    NSApp.activate(ignoringOtherApps: true)
//                    
//                    var error3: NSDictionary?
//                    if let scriptObject2 = NSAppleScript(source: appleScriptToAddCommands) {
//                        if let scriptResult: NSAppleEventDescriptor = scriptObject2.executeAndReturnError(
//                            &error3) {
//                        } else if (error3 != nil) {
//                            print(error3)
//                        }
//                    }
//                    
//                    PleaseWaitWindow.window?.close()
//                    
//                    //                    NSApp.abortModal()
//                    
//                    let msg4 = NSAlert()
//                    msg4.addButton(withTitle: "OK")
//                    msg4.messageText = "Finally, on the opened Dragon command window, click Save."
//                    msg4.informativeText = "This compiles the commands."
//                    
//                    msg4.runModal()
//                }
//        }
//        
//        else {
//            
//            let msg2 = NSAlert()
//            msg2.addButton(withTitle: "OK")      // 1st button
//            msg2.messageText = "There are no commands left to add."
//            
//            msg2.runModal()
//        }
//        
//        
//        
//        alertup = false
//        
//
//    }
    
    @IBAction func backupCommandsAsTxt(_ sender: NSMenuItem) {
        
        if defaults.object(forKey: "commands") != nil {
            var texttowrite = ""
            for (index, contents) in (defaults.stringArray(forKey: "commands")?.enumerated())! {
                texttowrite += "//-------- Tab " + String(index + 1) + " --------\n"
                texttowrite += contents + "\n"
            }
            
            writeFile(filename: "SpeakLaTeX_Commands.txt", stringToWrite: texttowrite)
            
            alertup = true
            let msg = NSAlert()
            msg.addButton(withTitle: "OK")
            msg.messageText = "Stored SpeakLaTeX commands saved to desktop."
            msg.runModal()
            alertup = false
        }
    }
    
    @IBAction func backupRegexAsTxt(_ sender: NSMenuItem) {
        
        if defaults.object(forKey: "regex") != nil {
            var texttowrite = ""
            for (index, contents) in (defaults.stringArray(forKey: "regex")?.enumerated())! {
                texttowrite += "//-------- Tab " + String(index + 1) + " --------\n"
                texttowrite += contents + "\n"
            }
            
            writeFile(filename: "SpeakLaTeX_Regex.txt", stringToWrite: texttowrite)
            
            alertup = true
            let msg = NSAlert()
            msg.addButton(withTitle: "OK")
            msg.messageText = "Stored SpeakLaTeX Regex repacements saved to desktop."
            msg.runModal()
            alertup = false
        }
    }
    
    @IBAction func exportDefaultCommandsAsTxt(_ sender: NSMenuItem) {
        
        var texttowrite = ""
        for (index, contents) in (DEFAULT_COMMANDS.enumerated()) {
            texttowrite += "//-------- Tab " + String(index + 1) + " --------\n"
            texttowrite += contents + "\n"
        }
        
        writeFile(filename: "SpeakLaTeX_Default_Commands.txt", stringToWrite: texttowrite)
        
        alertup = true
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")
        msg.messageText = "Default SpeakLaTeX commands saved to desktop."
        msg.runModal()
        alertup = false
    }
    
    @IBAction func exportDefaultRegexAsTxt(_ sender: NSMenuItem) {
        
        var texttowrite = ""
        for (index, contents) in (DEFAULT_REGEX.enumerated()) {
            texttowrite += "//-------- Tab " + String(index + 1) + " --------\n"
            texttowrite += contents + "\n"
        }
        
        writeFile(filename: "SpeakLaTeX_Default_Regex.txt", stringToWrite: texttowrite)
        
        alertup = true
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")
        msg.messageText = "Default SpeakLaTeX Regex replacements saved to desktop."
        msg.runModal()
        alertup = false
    }
    
    
    var phoneticarray: [NSTextField]!
    
    @IBAction func phoneticHelper(_ sender: NSMenuItem) {
        
        
        phoneticWindow.beenopened = true
        phoneticWindow.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        phoneticWindow.window?.title = "Phonetic Crib Sheet"
        
        phoneticWindow.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        phoneticWindow.window?.level = Int(CGWindowLevelForKey(.maximumWindow))
        
        for view in (phoneticWindow.window?.contentView?.subviews)!
        {
            view.removeFromSuperview()
        }
        
        
        phoneticarray = []
        
        func addTextFieldToPhoneticArray(string: String, size: Int, x: Int, y: Int) {
            let myTextField = NSTextField(frame: NSMakeRect(CGFloat(x),CGFloat(y),80,50))
            myTextField.stringValue = string
            myTextField.isBezeled = false
            myTextField.drawsBackground = false
            myTextField.isEditable = false
            myTextField.isSelectable = false
            myTextField.alignment = NSTextAlignment.center
            myTextField.font = NSFont(name: "Monaco", size: CGFloat(size))
            phoneticarray.append(myTextField)
        }
        
        
        var lettersArray: [String]! = ["a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z"]
        
        var letterAliasesArray = (defaults.stringArray(forKey: "letters"))!
        var i  = 0
        while letterAliasesArray.count > 0 {
            
            let xpos = (i % 13) * 60 - 5
            var ybase = 50
            if i > 12 {ybase = -34}
            
            addTextFieldToPhoneticArray(string: lettersArray.removeFirst(), size: 20, x: xpos, y: ybase + 62)
            addTextFieldToPhoneticArray(string: lettersArray.removeFirst(), size: 20, x: xpos, y: ybase + 24)
            
            let word = letterAliasesArray.removeFirst()
            addTextFieldToPhoneticArray(string: word, size: 13, x: xpos, y: ybase + 40)
            
            if letterAliasesArray.count > 0 {
                
                let word = letterAliasesArray.removeFirst()
                addTextFieldToPhoneticArray(string: word, size: 13, x: xpos, y: ybase + 2)
            }
            
            i += 1
            
        }
        
        for view in phoneticarray {
            phoneticWindow.window?.contentView?.addSubview(view)
        }
        
    }
    
    
    @IBAction func AboutSpeakLaTeXWindow(_ sender: NSMenuItem) {
        
        AboutSpeakLaTeXWindow.beenopened = true
        AboutSpeakLaTeXWindow.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    @IBAction func HelpMainWindow(_ sender: NSMenuItem) {
        
        HelpMainWindow.beenopened = true
        
        HelpMainWindow.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    @IBAction func HelpSyntaxWindow(_ sender: NSMenuItem) {
        
        HelpSyntaxWindow.beenopened = true
        
        HelpSyntaxWindow.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    

    
    @IBAction func addRecognisedWord(_ sender: NSMenuItem) {
        
        alertup = true
        
        let theAliasAlertController = AliasAlertController()
        
        if (recognisedCommandsWindow.beenopened == true && recognisedCommandsWindow.window?.isVisible == true) {
            theAliasAlertController.runAlert(currentTabs: recognisedCommandsWindow.tabStringsArray)
            recognisedCommandsWindow.loadStringsArrayFromDefaults()
            recognisedCommandsWindow.redoAttributedString()
        }
        else {
            var currentTabs = DEFAULT_COMMANDS
            if defaults.object(forKey: "commands") != nil {
                currentTabs = defaults.stringArray(forKey: "commands")!
            }
            theAliasAlertController.runAlert(currentTabs: currentTabs)
        }
        
        alertup = false
    }

}

class AliasAlertController: NSObjectController {
    
    @IBOutlet var AliasAlert: NSView!
    
    @IBOutlet var AliasField: NSTextField!
    
    @IBOutlet var IntendedWordField: NSTextField!
    
    func runAlert(currentTabs: [String]) {
        
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = "Add an alias for a command word."
        //msg.informativeText = "I'm an NSAlert."
        Bundle.main.loadNibNamed("AliasAlert", owner:self, topLevelObjects:nil)
        
        msg.accessoryView = AliasAlert
        msg.window.initialFirstResponder = AliasField
        
        let response: NSModalResponse = msg.runModal()
        
        if (response == NSAlertFirstButtonReturn) {
            appDelegate.MainRecognisedWordHandler.addRecognisedWordAlias(recognisedWord: IntendedWordField.stringValue, alias: AliasField.stringValue, currentTabs: currentTabs)
            
        }
    }
    
}
