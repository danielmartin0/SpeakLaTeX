import Foundation
import Cocoa


let defaults = UserDefaults.standard


class MyApplication: NSApplication {
    override func sendEvent(_ event: NSEvent) {
        if event.type == NSEventType.keyDown {
            
            if (event.modifierFlags.contains(NSEventModifierFlags.command)) {
                switch event.charactersIgnoringModifiers!.lowercased() {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return }
                case "a":
                    if NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self) { return }
                case "z":
                    if event.modifierFlags.contains(NSEventModifierFlags.shift) {
                        if NSApp.sendAction(Selector(("redo:")), to:nil, from:self) { return }
                    }
                    else {
                        if NSApp.sendAction(Selector(("undo:")), to:nil, from:self) { return }
                    }
                default:
                    break
                }
            }
        }
        return super.sendEvent(event)
    }
    
}

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
//    let str = "abcdef"
//    str[1 ..< 3] // returns "bc"
//    str[5] // returns "f"
//    str[80] // returns ""
//    str.substring(from: 3) // returns "def"
//    str.substring(to: str.length - 2) // returns "abcd"
//    ^^ above from https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
}


extension NSObject {
    func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> NSColor {
        return NSColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


func pressLeftKeyRepeatedly(times: Int) {
    if times > 0 {
        for i in 1...times {
            let doublei : Double = Double(i)
            
            let eventa = CGEvent(keyboardEventSource: nil, virtualKey: 123, keyDown: true)
            let eventb = CGEvent(keyboardEventSource: nil, virtualKey: 123, keyDown: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.018 + doublei * 0.014) {
                eventa!.post(tap: CGEventTapLocation.cgSessionEventTap)}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.023 + doublei * 0.014) {
                eventb!.post(tap: CGEventTapLocation.cgSessionEventTap)}
            
        }
    }
}

func keystroke(button: CGKeyCode) {
    let eventa = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: true)
    eventa!.post(tap: CGEventTapLocation.cgSessionEventTap)
    let eventb = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: false)
    eventb!.post(tap: CGEventTapLocation.cgSessionEventTap)
}


func tapButton(button: CGKeyCode) {
    let event = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: true)
    event!.post(tap: CGEventTapLocation.cgSessionEventTap)
}

func untapButton(button: CGKeyCode) {
    let event = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: false)
    event!.post(tap: CGEventTapLocation.cgSessionEventTap)
}


func cmdkeystroke(button: CGKeyCode) {
    let eventa = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: true)
    eventa?.flags = CGEventFlags.maskCommand;
    eventa!.post(tap: CGEventTapLocation.cgSessionEventTap)
    let eventb = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: false)
    eventb?.flags = CGEventFlags.maskCommand;
    eventb!.post(tap: CGEventTapLocation.cgSessionEventTap)
}


func ctrlkeystroke(button: CGKeyCode) {
    let eventa = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: true)
    eventa?.flags = CGEventFlags.maskControl;
    eventa!.post(tap: CGEventTapLocation.cgSessionEventTap)
    let eventb = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: false)
    eventb?.flags = CGEventFlags.maskControl;
    eventb!.post(tap: CGEventTapLocation.cgSessionEventTap)
}



func writeViaClipboard(text: String) {
    let pasteboard = NSPasteboard.general()
    let str = pasteboard.string(forType: NSPasteboardTypeString)

    pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
    pasteboard.setString(text, forType: NSPasteboardTypeString)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
        // temporary hack to make my X11 apps work... watch out!:
        if(NSWorkspace.shared().frontmostApplication?.localizedName == "X11") {
            ctrlkeystroke(button: 9)
        }
        else {
            cmdkeystroke(button: 9)
        }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
        pasteboard.setString(str!, forType: NSPasteboardTypeString)
    }
}

func loadFileAsString(filename: String) -> String {
    if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
        
        let path = dir.appendingPathComponent(filename)
        
        do {
            return try String(contentsOf: path, encoding: String.Encoding.utf8)
        }
        catch {print(error.localizedDescription); exit(0)}
    }
    return ""
}

func writeFile(filename: String, stringToWrite: String) {
    if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
        
        let path = dir.appendingPathComponent(filename)
        
        do {
            try stringToWrite.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {/* error handling here */}
    }
    
}


func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) s.")
}
