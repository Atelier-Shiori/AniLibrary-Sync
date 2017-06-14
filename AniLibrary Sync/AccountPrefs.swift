//
//  AccountPrefs.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/13.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Cocoa

class AccountPrefs: NSViewController, MASPreferencesViewController {
    
    @IBOutlet var myanimelistloginview: NSView!
    var MALLoginViewController: useraccountviewer?
    
    @IBOutlet var kitsuloginview: NSView!
    var KitsuLoginViewController: useraccountviewer?
    
    override var nibName: String? {
        get {
            return "AccountPrefs"
        }
    }
    
    override var identifier: String? {
        get {
            return "accounts"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage? {
        get {
            return NSImage(named: NSImageNameUserAccounts)!
        }
    }
    
    var toolbarItemLabel: String? {
        get {
            // dirty hack here: layout the view before `MASPreferencesWIndowController` getting `bounds`.
            view.layoutSubtreeIfNeeded()
            return NSLocalizedString("Accounts", comment: "Accounts")
        }
    }
    
    // view size is handled by AutoLayout, so it's not resizable
    var hasResizableWidth: Bool = false
    var hasResizableHeight: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        MALLoginViewController = useraccountviewer()
        if (!(MALLoginViewController?.isViewLoaded)!) {
            MALLoginViewController?.viewDidLoad()
        }
        myanimelistloginview.addSubview((MALLoginViewController?.view)!)
        MALLoginViewController?.loadserviceview(service: "MyAnimeList")
        
        KitsuLoginViewController = useraccountviewer()
        if (!(KitsuLoginViewController?.isViewLoaded)!) {
            KitsuLoginViewController?.viewDidLoad()
        }
        kitsuloginview.addSubview((KitsuLoginViewController?.view)!)
        KitsuLoginViewController?.loadserviceview(service: "Kitsu")
        
    }
    
}
