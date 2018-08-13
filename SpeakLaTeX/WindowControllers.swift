import Cocoa

protocol TextViewControllerDelegate: class {
    func updateStringArrayFromTextView()
}

class TextViewController: NSObject, NSTextViewDelegate {
    
    @IBOutlet var theTextView: NSTextView!
    weak var delegate:TextViewControllerDelegate?
    
    var rangeJustChanged: NSRange!
    var colourslimited: Bool = false
    
    
    override init() {
        super.init()
        
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString text: String?) -> Bool {
        rangeJustChanged = NSMakeRange(range.location, (text?.characters.count)!)
        if ((text?.contains("\t"))! || (text?.contains("“"))! || (text?.contains("”"))!) {
            //textView.insertText(text as Any, replacementRange: range)
            textView.insertText(text?.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "“", with: "\"").replacingOccurrences(of: "”", with: "\"") as Any, replacementRange: range)
            return false
        }
        else {
            return true
        }
    }
    
    func textDidChange(_ notification: Notification) {
        
            delegate?.updateStringArrayFromTextView()

            let earlierSubstring = theTextView.textStorage!.string.substring(to: rangeJustChanged.location)
            let laterSubstring = theTextView.textStorage!.string.substring(from: rangeJustChanged.location + rangeJustChanged.length)
            
            let startOfNewRange = theTextView.textStorage!.string.distance(from: earlierSubstring.startIndex, to: earlierSubstring.range(of: "\n", options: [.backwards])?.lowerBound ?? earlierSubstring.startIndex)
            let endOfNewRange = theTextView.textStorage!.string.distance(from: laterSubstring.startIndex, to: laterSubstring.index(of: "\n") ?? laterSubstring.endIndex) + rangeJustChanged.location + rangeJustChanged.length
            
            adjustColoursAroundRange(startIndexAsInt: startOfNewRange, endIndexAsInt: endOfNewRange)

    }
    
    func adjustColoursAroundRange(startIndexAsInt: Int, endIndexAsInt: Int) {
        let normalColorAttribute = [NSForegroundColorAttributeName: RGB(r: 0, g: 139, b: 247)]
        let commentColorAttribute = [NSForegroundColorAttributeName: RGB(r: 7, g: 180, b: 0)]
        let commandColorAttribute = [NSForegroundColorAttributeName: NSColor.black]
        var currentCommandColorAttribute = commandColorAttribute
        let extracommandColorAttribute = [NSForegroundColorAttributeName: NSColor.black]
        let cursorColorAttribute = [NSForegroundColorAttributeName: RGB(r: 185, g: 76, b: 225)]
        let newlineColorAttribute = [NSForegroundColorAttributeName: RGB(r: 255, g: 198, b: 0)]
        //let newlineColorAttribute = [NSForegroundColorAttributeName: RGB(r: 0, g: 60, b: 255)]
        //let cursorColorAttribute = [NSForegroundColorAttributeName: RGB(r: 255, g: 185, b: 0)]
        //let repeaterColorAttribute = [NSForegroundColorAttributeName: RGB(r: 255, g: 77, b: 154)]
        let exclamationCommandColorAttribute = [NSForegroundColorAttributeName: RGB(r: 255, g: 150, b: 0)]
        let lineCommandColorAttribute = [NSForegroundColorAttributeName: RGB(r: 255, g: 0, b: 54)]
        
        if endIndexAsInt > startIndexAsInt {
            
            var expandedString = ""
            if (startIndexAsInt == 0 && endIndexAsInt == (theTextView.string?.characters.count)!) {
                expandedString = theTextView.textStorage!.string
            }
            else {
                expandedString = theTextView.textStorage!.string[Range(startIndexAsInt ..< endIndexAsInt)]
            }
            
            var lines = expandedString.components(separatedBy: "\n")
            lines.append("")
            
            var indexes = expandedString.indexes(of: "\n")
            indexes = indexes.map({expandedString.index($0, offsetBy: 1)})
            if startIndexAsInt == 0 {
                indexes.insert(expandedString.startIndex, at: 0)
                lines.insert("", at: 0)
            }
            
            for index in 0..<indexes.count {
                let thisline = lines[index+1]
                let indexOfLineStart = startIndexAsInt + expandedString.distance(from: expandedString.startIndex, to: indexes[index])
                
                let fullRange = NSMakeRange(indexOfLineStart, thisline.characters.count)
                if thisline[0 ..< 2] == "//" {
                    theTextView.textStorage!.addAttributes(commentColorAttribute, range: fullRange)
                }
                else {
                    
                    
                    if (colourslimited == true) {
                    theTextView.textStorage!.addAttributes([NSForegroundColorAttributeName: NSColor.black], range: fullRange)
                    }
                    else {
                        theTextView.textStorage!.addAttributes(normalColorAttribute, range: fullRange)
                        
                        
                        if thisline.characters.count > 0 {
                            let firstchar = thisline[0]
                            if firstchar == "!" {
                                currentCommandColorAttribute = exclamationCommandColorAttribute
                            }
                            else {
                                if firstchar == "|" {
                                    currentCommandColorAttribute = lineCommandColorAttribute
                                }
                                else {
                                    currentCommandColorAttribute = commandColorAttribute
                                }
                            }
                        }
                        
                        var newlineindexes = thisline.indexes(of: NEW_LINE_DELIMITER)
                        for newlineindex in 0..<newlineindexes.count {
                            let newlineRange = NSMakeRange(indexOfLineStart + thisline.distance(from: thisline.startIndex, to: newlineindexes[newlineindex]),1)
                            theTextView.textStorage!.addAttributes(newlineColorAttribute, range: newlineRange)
                        }
                        var cursorindexes = thisline.indexes(of: POINTER_DELIMITER)
                        for cursorindex in 0..<cursorindexes.count {
                            let cursorRange = NSMakeRange(indexOfLineStart + thisline.distance(from: thisline.startIndex, to: cursorindexes[cursorindex]),1)
                            theTextView.textStorage!.addAttributes(cursorColorAttribute, range: cursorRange)
                        }
//                        var repeaterindexes = thisline.indexes(of: REPEATER_DELIMITER)
//                        for repeaterindex in 0..<repeaterindexes.count {
//                            let distancetorepeater = thisline.distance(from: thisline.startIndex, to: repeaterindexes[repeaterindex])
//                            let distancefromrepeatertoend = thisline.distance(from: repeaterindexes[repeaterindex], to: thisline.endIndex)
//                            if distancefromrepeatertoend > 1 {
//                                let nextcharacter = thisline[distancetorepeater + 1]
//                                if (nextcharacter == "1" || nextcharacter == "2" || nextcharacter == "3" || nextcharacter == "4" || nextcharacter == "5" || nextcharacter == "6" || nextcharacter == "7" || nextcharacter == "8" || nextcharacter == "9") {
//                                    let repeaterRange = NSMakeRange(indexOfLineStart + thisline.distance(from: thisline.startIndex, to: repeaterindexes[repeaterindex]),2)
//                                    theTextView.textStorage!.addAttributes(repeaterColorAttribute, range: repeaterRange)
//                                }
//                            }
//                        }
                        
                        
                        
                        
                        var multiindexes = thisline.indexes(of: LOOP_COMMAND_DELIMITER)
                        var multiparts = thisline.components(separatedBy: LOOP_COMMAND_DELIMITER)
                        var inside = false
                        for piece in 0..<multiparts.count {
                            if (inside == true && piece < multiparts.count - 1) {
                                if !multiparts[piece].contains(WORD_COMMAND_DELIMITER) {
                                    let previousIndexOfMulti = thisline.distance(from: thisline.startIndex, to: multiindexes[piece - 1])
                                    let thisIndexOfMulti = thisline.distance(from: thisline.startIndex, to: multiindexes[piece])
                                    let multiRange = NSMakeRange(indexOfLineStart + previousIndexOfMulti,thisIndexOfMulti - previousIndexOfMulti + 1)
                                    theTextView.textStorage!.addAttributes(extracommandColorAttribute, range: multiRange)
                                }
                            }
                            inside = !inside
                        }
                        
                        var singleindexes = thisline.indexes(of: WORD_COMMAND_DELIMITER)
                        var singleparts = thisline.components(separatedBy: WORD_COMMAND_DELIMITER)
                        var inside2 = false
                        for piece in 0..<singleparts.count {
                            if (inside2 == true && piece < singleparts.count - 1) {
                                if !singleparts[piece].contains(LOOP_COMMAND_DELIMITER) {
                                    let previousIndexOfsingle = thisline.distance(from: thisline.startIndex, to: singleindexes[piece - 1])
                                    let thisIndexOfsingle = thisline.distance(from: thisline.startIndex, to: singleindexes[piece])
                                    let singleRange = NSMakeRange(indexOfLineStart + previousIndexOfsingle,thisIndexOfsingle - previousIndexOfsingle + 1)
                                    theTextView.textStorage!.addAttributes(extracommandColorAttribute, range: singleRange)
                                }
                            }
                            inside2 = !inside2
                        }
                        
//                        var colonindexes = thisline.indexes(of: ":")
//                        var parts = thisline.components(separatedBy: ":")
//                        for colonindex in 0..<colonindexes.count {
//                            let relativeIndexOfColon = thisline.distance(from: thisline.startIndex, to: colonindexes[colonindex])
//                            if (colonindex == 0)
//                            {
//                                let colonRange = NSMakeRange(indexOfLineStart, relativeIndexOfColon + 2)
//                                theTextView.textStorage!.addAttributes(commandColorAttribute, range: colonRange)
//                            }
                        //                        }
                        var colonindexes = thisline.indexes(of: ":")
                        if colonindexes.count == 0 {
                            let colonRange = NSMakeRange(indexOfLineStart, thisline.distance(from: thisline.startIndex, to: thisline.endIndex))
                            if colonRange.location + colonRange.length - 1 < theTextView.textStorage!.string.characters.count {
                                
                                theTextView.textStorage!.addAttributes(currentCommandColorAttribute, range: colonRange)
                            }
                        }
                        else {
                            var colonorbreakdistance = thisline.distance(from: thisline.startIndex, to: colonindexes[0])
                            if (colonorbreakdistance != thisline.characters.count - 1) {
                                let nextchar = thisline.characters.index(colonindexes[0], offsetBy: 1)
                                if (thisline[nextchar] == "_" || thisline[nextchar] == "^") {
                                    let aftercolon = thisline.components(separatedBy: ":")[1]
                                    if (aftercolon.indexes(of: " ") != []) {
                                        colonorbreakdistance += aftercolon.distance(from: aftercolon.startIndex, to: aftercolon.indexes(of: " ")[0])
                                    }
                                    else {
                                        colonorbreakdistance += aftercolon.distance(from: aftercolon.startIndex, to: aftercolon.endIndex)
                                    }
                                }
                                if (thisline[nextchar] == "!") {
                                    if (colonorbreakdistance != thisline.characters.count - 2) {
                                        let nextnextchar = thisline.characters.index(colonindexes[0], offsetBy: 2)
                                        if (thisline[nextnextchar] == "_" || thisline[nextnextchar] == "^") {
                                            let aftercolon = thisline.components(separatedBy: ":")[1]
                                            if (aftercolon.indexes(of: " ") != []) {
                                                colonorbreakdistance += aftercolon.distance(from: aftercolon.startIndex, to: aftercolon.indexes(of: " ")[0])
                                            }
                                            else {
                                                colonorbreakdistance += aftercolon.distance(from: aftercolon.startIndex, to: aftercolon.endIndex)
                                            }
                                        }
                                    }
                                }
                            }
                            let colonRange = NSMakeRange(indexOfLineStart, colonorbreakdistance + 1)
                            theTextView.textStorage!.addAttributes(currentCommandColorAttribute, range: colonRange)
                        }
                        
                        
                    }
                }
            }
        }
    }
}



class TextWindow: NSWindowController, NSWindowDelegate, NSTabViewDelegate, TextViewControllerDelegate {

    
    var beenopened: Bool = false
    var defaultsKey: String!
    var otherwiseDefaultsVariable: [String]!
    var title: String = ""
    
    var tabItems: [NSTabViewItem]! = []
    var tabStringsArray: [String]! = []
    var tabScrollPositions: [NSPoint]! = []
    
    var currentTab = 0
    let tabCount = 4
    
    var changesMade = false
    
    override var windowNibName : String! {
        return "TextWindow"
    }
    
    
//    let myTextField = NSTextField(frame: NSMakeRect(20,20,200,40))
    
    
    @IBOutlet var TabView: NSTabView!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        
        window?.title = title
        
        window!.setContentBorderThickness(36.0, for: NSRectEdge.minY)
        
        window!.delegate = self
        TabView.delegate = self
        MainTextViewController1.delegate = self
        
        if defaultsKey == "regex" {
            MainTextViewController1.colourslimited = true
        }
        
        window!.styleMask.insert(.resizable)
        
        
        
        
        for _ in 0..<tabCount {
            tabScrollPositions.append(NSMakePoint(0.0,0.0))
        }
        

        
        //let clipOrigin = MainTextViewController1.theTextView.enclosingScrollView?.visibleRect.origin
        
        for i in 0..<tabCount {
            tabStringsArray.append("")
            let tabToAppend = NSTabViewItem()
            tabToAppend.label = "   Tab " + String(i + 1) + "   "
            tabItems.append(tabToAppend)
            TabView.addTabViewItem(tabToAppend)
        }
        
//        myTextField.backgroundColor = NSColor.red
//        myTextField.isBezeled = false
//        myTextField.stringValue = "HELLO"
//        TabView.addSubview(myTextField)
        
//        NSTextField *infoTextField = [[NSTextField alloc] initWithFrame:rect];
//        [[window contentView] addSubview:infoTextField];
//        [infoTextField setDelegate:self];
//        [[infoTextField window] becomeFirstResponder];
//        [infoTextField setTextColor:[NSColor blackColor]];
//        [infoTextField setDrawsBackground:YES];
//        [infoTextField setBordered:YES];
//        [infoTextField setSelectable:YES];
//        [infoTextField setEditable:YES];
//        [infoTextField setEnabled:YES];
//        [infoTextField setAlignment:NSLeftTextAlignment];
//        [infoTextField setStringValue:@"What are you doing?"];
//        [infoTextField release];
        
    }
    
    @IBOutlet var MainTextViewController1: TextViewController!
    
    
    func openWindow() {
        beenopened = true
        
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        if defaults.object(forKey: defaultsKey) == nil {
            defaults.set(otherwiseDefaultsVariable, forKey: defaultsKey)
        }
        
        while (defaults.stringArray(forKey: defaultsKey)?.count)! < tabStringsArray.count {
            var previousDefault = (defaults.stringArray(forKey: defaultsKey))!
            previousDefault.append("")
            defaults.set(previousDefault, forKey: defaultsKey)
        }
        
        loadStringsArrayFromDefaults()
        
        redoAttributedString()
    }
    
    func loadStringsArrayFromDefaults() {
        for i in 0..<tabStringsArray.count {
            tabStringsArray[i] = (defaults.stringArray(forKey: defaultsKey)?[i])!// ?? otherwiseDefaultsVariable[i]
        }
    }
    
    
    internal func updateStringArrayFromTextView() {
        changesMade = true
        
        for (index, tab) in tabItems.enumerated() {
            if (TabView.selectedTabViewItem == tab) {
                tabStringsArray[index] = MainTextViewController1.theTextView.textStorage!.string
            }
        }
    }
    
    
    @IBAction func saveButton(_ sender: NSButton) {
        
        saveChanges()
        
        changesMade = false
    }
    
    func saveChanges() {
        
        var arrayToWrite: [String]! = []
        for i in 0..<tabStringsArray.count {
            arrayToWrite.append(tabStringsArray[i])
        }
        defaults.set(arrayToWrite, forKey: defaultsKey)
        appDelegate.refreshEverything()
    }
    
    func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        for (index, tab) in tabItems.enumerated() {
            if (tabViewItem == tab) {
                //tabScrollPositions[currentTab] = (MainTextViewController1.theTextView.enclosingScrollView?.contentView.documentVisibleRect.origin)!
                
                currentTab = index
                redoAttributedString()
                
                MainTextViewController1.theTextView.enclosingScrollView?.contentView.scroll(NSMakePoint(0.0,0.0))
                //MainTextViewController1.theTextView.enclosingScrollView?.contentView.scroll(tabScrollPositions[index])
            }
        }
    }
    
    func redoAttributedString() {
        
        let textInView = tabStringsArray[currentTab]
        
        let normalColorAttribute = [NSForegroundColorAttributeName: NSColor.black]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.paragraphSpacingBefore = 0
        
        let LargeNumberForText: CGFloat = 1.0e7
 
        
        let attrStr = NSMutableAttributedString(string: textInView, attributes: normalColorAttribute)
        attrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        MainTextViewController1.theTextView.isEditable = true
        MainTextViewController1.theTextView.textContainer!.containerSize = NSMakeSize(LargeNumberForText, LargeNumberForText)
        MainTextViewController1.theTextView.textContainer!.widthTracksTextView = false
        MainTextViewController1.theTextView.isHorizontallyResizable = true
        MainTextViewController1.theTextView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        MainTextViewController1.theTextView.isAutomaticQuoteSubstitutionEnabled = false
        MainTextViewController1.theTextView.isAutomaticDashSubstitutionEnabled = false
        MainTextViewController1.theTextView.isAutomaticTextReplacementEnabled = false
        MainTextViewController1.theTextView.usesFindBar = true
        //MainTextViewController1.theTextView.backgroundColor = RGB(r: 50, g: 0, b: 0)
        
        
        MainTextViewController1.theTextView.textStorage!.setAttributedString(attrStr)
        MainTextViewController1.theTextView.font = NSFont(name: "Monaco", size: 12)
        
        if textInView != "" {
            MainTextViewController1.adjustColoursAroundRange(startIndexAsInt: 0, endIndexAsInt: MainTextViewController1.theTextView.textStorage!.string.distance(from: MainTextViewController1.theTextView.textStorage!.string.startIndex, to: MainTextViewController1.theTextView.textStorage!.string.endIndex))
        }
    }
    
    
    
    
    func windowWillClose(_ notification: Notification) {
        
        if changesMade == true {
            let msg = NSAlert()
            msg.addButton(withTitle: "Save")      // 1st button
            msg.addButton(withTitle: "Don't Save")  // 2nd button
            msg.messageText = "Do you want to save?"
            msg.informativeText = "Any unsaved changes will be reverted."
            
            let response: NSModalResponse = msg.runModal()
            
            if (response == NSAlertFirstButtonReturn) {
                saveChanges()
            }
        }
    }
    
}



class PhoneticWindowController: NSWindowController, NSWindowDelegate {
    
    var beenopened: Bool = false
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window!.delegate = self
        
    }
}


class PleaseWaitController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window!.delegate = self
        
        window?.center()
        
    }
    
    override var windowNibName : String! {
        return "PleaseWait"
    }
}



class AboutSpeakLaTeXWindowController: NSWindowController, NSWindowDelegate {
    
    var beenopened: Bool = false
    
    @IBOutlet var versionNumberLabel: NSTextField!
    
    @IBOutlet var copyrightLabel: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let appVersion = String(describing: (Bundle.main.infoDictionary?["CFBundleShortVersionString"])!)
        let appBuild = String(describing: (Bundle.main.infoDictionary?["CFBundleVersion"])!)
        let copyrightText = String(describing: (Bundle.main.infoDictionary?["NSHumanReadableCopyright"])!)
        
        versionNumberLabel.stringValue = "Version " + appVersion + " (" + appBuild + ")\nhttps://github.com/danielmartin0/SpeakLaTeX"
        copyrightLabel.stringValue = copyrightText
        //copyrightLabel.stringValue = "Copyright © Daniel Martin " + stringYear + ".\n All rights reserved."
        
        window!.delegate = self
        
        window?.center()
        
    }
    
    override var windowNibName : String! {
        return "AboutSpeakLaTeX"
    }
}

class HelpWindowController: NSWindowController, NSWindowDelegate {
    
    var beenopened: Bool = false
    var myString: String = ""
    var myTitle: String = ""
    
    @IBOutlet var helpTextView: NSTextView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        helpTextView.string = myString
        
        window!.title = myTitle
        
        window!.delegate = self
        
        window?.center()
        
    }
    
    override var windowNibName : String! {
        return "Help"
    }
}
