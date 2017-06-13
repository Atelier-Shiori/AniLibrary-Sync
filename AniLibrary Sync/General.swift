//
//  General.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/13.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Cocoa
import MASPreferences

class General: NSViewController, MASPreferencesViewController {
    override var nibName: String? {
        get {
            return "General"
        }
    }
    
    override var identifier: String? {
        get {
            return "general"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage? {
        get {
            return NSImage(named: NSImageNamePreferencesGeneral)!
        }
    }
    
    var toolbarItemLabel: String? {
        get {
            // dirty hack here: layout the view before `MASPreferencesWIndowController` getting `bounds`.
            view.layoutSubtreeIfNeeded()
            return NSLocalizedString("General", comment: "General")
        }
    }
    
    // view size is handled by AutoLayout, so it's not resizable
    var hasResizableWidth: Bool = false
    var hasResizableHeight: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
