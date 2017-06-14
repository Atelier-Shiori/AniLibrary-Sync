//
//  AppDelegate.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/05/31.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var statusmenu: NSMenu!
    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem?
    var statusImage: NSImage?
    var preferenceWindow : NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let images : Array<String> = ["sync"]
        for imagename in images {
            let image : NSImage = NSImage.init(named: imagename)!
            image.isTemplate = true
        }
        // Create NSStatusItem
        statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        statusImage = NSImage.init(named: "sync")
        statusImage?.isTemplate = true
        statusItem?.image = statusImage
        statusItem!.menu = statusmenu
        // Set defaults
        self.setdefaultvalues()
    }
    
    func setdefaultvalues() {
        let defaultsettings: Dictionary<String,Any> = ["donated":false, "MALAPIURL":"https://malapi.ateliershiori.moe"]
        UserDefaults.standard.register(defaults: defaultsettings)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func preferencesWindowController() -> NSWindowController {
        if (preferenceWindow == nil) {
            let generalViewController = General()
            let accountViewController = AccountPrefs()
            let controllers : Array<NSViewController> = [generalViewController, accountViewController]
            preferenceWindow = MASPreferencesWindowController.init(viewControllers: controllers)
        }
        return preferenceWindow!
    }

    @IBAction func showPreferences(sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        self.preferencesWindowController().showWindow(sender)
    }
}

