import Foundation
import Cocoa
import JavaScriptCore
// import ORSSerialPort.h

let appDelegate = NSApplication.shared().delegate as! AppDelegate

//var STOREDFROMDRAGON = ""
var DISABLEMOREINPUT = false
var OSXDICTON = false

var SPEAKLATEX_ACTIVE = true

let WAITAFTERSINGLEWORD = 0.0

var OS_DICT_ALREADY_TOOK_THIS_WORD = ""

let ONPHRASE = "math start"
let OFFPHRASE = "math stop"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechRecognizerDelegate {
    
    var context = JSContext()!
    var MainRecognisedWordHandler = RecognisedWordHandler()
    var MainLaTeXHandler = LaTeXHandler()
    var SR: NSSpeechRecognizer?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        if let bundle = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundle)
//        }
        
        if defaults.object(forKey: "commands") == nil {
            defaults.set(DEFAULT_COMMANDS, forKey: "commands")
        }
        if defaults.object(forKey: "regex") == nil {
            defaults.set(DEFAULT_REGEX, forKey: "regex")
        }
        
        appDelegate.refreshEverything()
        
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func refreshEverything() {
        MainRecognisedWordHandler.loadCorrectors()
        MainLaTeXHandler.refreshcommands()
    }
    
    func MacOSDictStopListening() {
        SR?.stopListening()
        
//        NSWorkspace.shared().notificationCenter.removeObserver(self, name: .NSWorkspaceWillSleep, object: nil)
//        NSWorkspace.shared().notificationCenter.removeObserver(self, name: .NSWorkspaceDidWake, object: nil)
        SR = nil
        
        NSApplication.shared().resignFirstResponder()
    }
    
    func MacOSDictResumeListening(){
        NSApplication.shared().becomeFirstResponder()
        
        SR = NSSpeechRecognizer()
        
//        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.MacOSDictStopListening), name: .NSWorkspaceWillSleep, object: nil)
//        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.MacOSDictResumeListening), name: .NSWorkspaceDidWake, object: nil)
        
        let MacOSDictCommands = MainRecognisedWordHandler.wordsToTriggerOSSpeech
        
        SR?.commands = MacOSDictCommands
        SR?.delegate = self
        SR?.listensInForegroundOnly = false
        SR?.displayedCommandsTitle = "Words"
        
        SR?.startListening(); print("listening")
    }
    
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: AnyObject?) {
        print("macos: " + (command as! String))
        
        for recognisedWord in MainRecognisedWordHandler.wordsToTriggerOSSpeech {
            if (command as! String == recognisedWord)
            {
                if DISABLEMOREINPUT == false {
                    if SPEAKLATEX_ACTIVE == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + WAITAFTERSINGLEWORD) {
                            if DISABLEMOREINPUT == false {
                                appDelegate.MainLaTeXHandler.writeLaTeX(dictation: command as! String)
                                OS_DICT_ALREADY_TOOK_THIS_WORD = recognisedWord
                                DeclineText()
                            }
                        }
                    }
                    else {
                        writeViaClipboard(text: " " + (command as! String))
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + WAITAFTERSINGLEWORD + 1.2) {
                        AcceptText()
                        OS_DICT_ALREADY_TOOK_THIS_WORD = ""
                    }
                }
                
            }
        }
    }
}



class WriteScriptCommand: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {
        
        let dictation = self.evaluatedArguments!["Dictation"] as! String
        print("dragon: " + dictation)
        
        if (SPEAKLATEX_ACTIVE == true)  { //DISABLEMOREINPUT used to be checked also
            
            printTimeElapsedWhenRunningCode(title:"writeLaTeX") {
                appDelegate.MainLaTeXHandler.writeLaTeX(dictation: dictation)
            }
        }
        else {
            writeViaClipboard(text: " " + dictation)
        }
        
        DeclineText()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AcceptText()
        }
        
        
        return ""
    }
}


func AcceptText() {
    DISABLEMOREINPUT = false
}

func DeclineText() {
    DISABLEMOREINPUT = true
}




let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)



class disableScriptCommand: NSScriptCommand {
    
    override func performDefaultImplementation() -> Any? {
    
        disableSpeakLaTeX()
        
        return ""
    }
}

class enableScriptCommand: NSScriptCommand {
    
    override func performDefaultImplementation() -> Any? {
        
        enableSpeakLaTeX()
        
        return ""
    }
}

func disableSpeakLaTeX() {
    
    SPEAKLATEX_ACTIVE = false
    
    if OSXDICTON == true {
        appDelegate.MacOSDictStopListening()
    }
    let icon = NSImage(named: "statusIconDisabled")
    icon?.isTemplate = true // best for dark mode
    statusItem.image = icon
}

func enableSpeakLaTeX() {
    
    SPEAKLATEX_ACTIVE = true
    
    if OSXDICTON == true {
        appDelegate.MacOSDictResumeListening()
    }
    let icon = NSImage(named: "statusIconEnabled")
    icon?.isTemplate = true // best for dark mode
    statusItem.image = icon
}

