//
//  ConfigWindowController.swift
//  WebSaver
//
//  Created by Jeremy Sachs on 3/22/19.
//  Copyright © 2019 Rezmason.net. All rights reserved.
//

import ScreenSaver

final class ConfigWindowController: NSWindowController {
    
    private let webAddressKey:String = "webAddress"
    @IBOutlet weak var webAddressTextField: NSTextField!
    
    public var webAddress:String {
        get {
            return defaults?.string(forKey: webAddressKey) ?? "http://rezmason.net"
        }
    }
    
    override var windowNibName: String {
        return "ConfigSheet"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webAddressTextField.stringValue = webAddress
    }
    
    private let defaults:ScreenSaverDefaults? = {
        return ScreenSaverDefaults(forModuleWithName: Bundle(for: ConfigWindowController.self).bundleIdentifier! )
    }()
    
    @IBAction func ok(_ sender: Any?) {
        
        defaults?.set(webAddressTextField.stringValue, forKey: webAddressKey)
        defaults?.synchronize()
        
        NotificationCenter.default.post(name: ConfigChanged, object: nil)
        self.window?.sheetParent?.endSheet(self.window!)
    }
    
    @IBAction func cancel(_ sender: Any?) {
        self.window?.sheetParent?.endSheet(self.window!)
    }
}
