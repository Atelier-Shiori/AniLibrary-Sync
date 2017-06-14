//
//  useraccountviewer.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/13.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Cocoa

class useraccountviewer: NSViewController {
    @IBOutlet var userloginview: NSView!
    @IBOutlet var pinview: NSView!
    @IBOutlet var loggedinview: NSView!
    var serviceset: String?
    // Username/Password Login
    @IBOutlet var usernamefield: NSTextField!
    @IBOutlet var passwordfield: NSSecureTextField!
    @IBOutlet var loginbtn: NSButton!
    
    // Pin Login
    @IBOutlet var pinfield: NSSecureTextField!
    @IBOutlet var pinloginbtn: NSButton!
    
    // Loggedin
    @IBOutlet var loggedinusername: NSTextField!
    
    override var nibName: String? {
        get {
            return "useraccountviewer"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    func loadserviceview(service:String){
        if (service == "MyAnimeList"){
            if (MyAnimeList.retrieveAccountUsername() != "") {
                clearsubviews()
                self.view.addSubview(loggedinview)
                loggedinusername.stringValue = MyAnimeList.retrieveAccountUsername();
            }
            else {
                clearsubviews()
                self.view.addSubview(userloginview)
            }
        }
        else if (service == "Kitsu"){
            if (Kitsu.retrieveAccountUsername() != "") {
                clearsubviews()
                self.view.addSubview(loggedinview)
                loggedinusername.stringValue = Kitsu.retrieveAccountUsername();
            }
            else {
                clearsubviews()
                self.view.addSubview(userloginview)
            }
        }
        else if (service == "AniList"){
            
        }
        serviceset = service
    }
    // Username Login
    @IBAction func performusernamelogin(_ sender: Any) {
        if (serviceset == "MyAnimeList" || serviceset == "Kitsu") {
            if (usernamefield.stringValue.characters.count == 0 || passwordfield.stringValue.characters.count == 0) {
                Utility.showSheetMessage(message: "AniLibrary Sync was unable to log you in since you didn't enter a username or password", explainmessage: "Enter a valid username and try logging in again", w: self.view.window)
            }
            else {
                performLogin()
            }
        }
        else if (serviceset == "AniList") {
            if (pinfield.stringValue.characters.count == 0) {
                Utility.showSheetMessage(message: "AniLibrary Sync was unable to log you in since you didn't enter a pin", explainmessage: "Please retrieve a pin and copy it to the pin field.", w: self.view.window)
            }
            else {
                performLogin()
            }
        }
    }
    func performLogin() {
        if (serviceset == "MyAnimeList")
        {
            self.loginbtn.isEnabled = false
            MyAnimeList.login(username: usernamefield.stringValue, password: passwordfield.stringValue, success: {
                (result: Any) in
                self.loginbtn.isEnabled = true
                if (MyAnimeList.saveaccount(username: self.usernamefield.stringValue, password:     self.passwordfield.stringValue)) {
                    self.loggedinusername.stringValue = MyAnimeList.retrieveAccountUsername()
                    self.loadserviceview(service: self.serviceset!)
                    Utility.showSheetMessage(message: "Login Successful", explainmessage: "Login is successful", w: self.view.window)
                }
                else {
                    Utility.showSheetMessage(message: "Login not successful", explainmessage: "Couldn't save user credentials to the login keychain. Make sure you have access to it and try again.", w: self.view.window)
                }
            }, error: {
                (error: Error) in
                self.loginbtn.isEnabled = true
                Utility.showSheetMessage(message: "AniLibrary Sync was unable to log you in" , explainmessage: error.localizedDescription, w: self.view.window)
            })
        }
        else if (serviceset == "Kitsu"){
            self.loginbtn.isEnabled = false
            Kitsu.login(username: usernamefield.stringValue, password: passwordfield.stringValue, completion: {
                success,error in
                self.loginbtn.isEnabled = true
                if (success) {
                    self.loggedinusername.stringValue = Kitsu.retrieveAccountUsername()
                    self.loadserviceview(service: self.serviceset!)
                    Utility.showSheetMessage(message: "Login Successful", explainmessage: "Login is successful", w: self.view.window)
                }
                else {
                    if (error != nil){
                        Utility.showSheetMessage(message: "AniLibrary Sync was unable to log you in" , explainmessage: (error?.localizedDescription)!, w: self.view.window)
                    }
                    else {
                        Utility.showSheetMessage(message: "Login not successful", explainmessage: "Couldn't save user credentials to the login keychain. Make sure you have access to it and try again.", w: self.view.window)
                    }
                }
            })
        }
    }
    
    @IBAction func removeAccount(_ sender: Any) {
        let alert: NSAlert = NSAlert()
        alert.messageText = "Are you sure you want to remove this account?"
        alert.informativeText = "Once done, it cannot be undone."
        alert.alertStyle = NSInformationalAlertStyle
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.beginSheetModal(for: self.view.window!, completionHandler: {
            (responsecontext: NSModalResponse) in
            if (responsecontext == NSAlertFirstButtonReturn) {
                self.performaccountremoval()
            }
        })
    }
    
    func performaccountremoval() {
        if (serviceset == "MyAnimeList") {
            if (MyAnimeList.removeaccount()) {
                loadserviceview(service: serviceset!)
            }
        }
        else if (serviceset == "Kitsu"){
            
        }
        else if (serviceset == "AniList"){
            
        }
    }
    
    func clearsubviews() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
}
