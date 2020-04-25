//
//  AppDelegate.swift
//  NMSalahPRO
//
//  Created by Navid on 4/23/20.
//  Copyright © 2020 UnitedStar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var fajrTIME = ""
    var dhuhrTIME = ""
    var assrTIME = ""
    var maghribTIME = ""
    var ishaTIME = ""
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            //            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.title = "LOADING..."
            button.action = #selector(loadSalahTime(_:))
        }
        
        statusItem.length = CGFloat(100)
        
        constructMenu()
        refreshSalahTime()
//        let stf = SalahTimeFetch()
//        stf.refreshSalahTime()
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func loadSalahTime(_ sender: Any?) {
        refreshSalahTime()
    }
    
    //    func loadMenuItem2() {
    //
    //    }
    
}

extension AppDelegate {
    
    func constructMenu() {
        let menu = NSMenu()
        
        let Refresh_MI = NSMenuItem(title: "REFRESH SALAH TIME", action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "P")
        let Sep_MI = NSMenuItem.separator()
        let Quit_MI = NSMenuItem(title: "QUIT", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        menu.addItem(Refresh_MI)
        menu.addItem(Sep_MI)
        menu.addItem(Quit_MI)
        statusItem.menu = menu
    }
    
    private func refreshSalahTime(){
        
        let session = URLSession.shared
        
        let zipcode = "08876"
        let method = "4"
        let juristic = "1"
        let country = "US"
        let urlString = "https://www.islamicfinder.us/index.php/api/prayer_times?country=\(country)&zipcode=\(zipcode)&method=\(method)&juristic=\(juristic)"
        let apiURL = URL(string: urlString)
        let task = session.dataTask(with: apiURL!, completionHandler: callBackKoro)
        task.resume()
    }
    
    //    INTERNAL FUNCTIONS
    
    private func callBackKoro(data:Data?, response:URLResponse?, error:Error?) -> Void {
        if data != nil {
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let dictionary = json as? [String: Any] {
                
                if let number = dictionary["results"] as? [String: String] {
                    
                    for (key, value) in number {
                        
                        if(key == "Fajr") { self.fajrTIME  = value.filter({$0 != "%"}) }
                        if(key == "Asr") { self.assrTIME  = value.filter({$0 != "%"}) }
                        if(key == "Dhuhr") { self.dhuhrTIME  = value.filter({$0 != "%"}) }
                        if(key == "Maghrib") { self.maghribTIME  = value.filter({$0 != "%"}) }
                        if(key == "Isha") { self.ishaTIME  = value.filter({$0 != "%"}) }
                    }
                    
                    loadMenuItem()
                    print("DONE!")
                } else { print("no results") }
                
            } else { print("NO DATA") }
            
        } else {
            print("FAILED!")
        }
    }
    
    func loadMenuItem(){
        let FAJR_MI = NSMenuItem(title: self.fajrTIME, action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "")
        let DHUHR_MI = NSMenuItem(title: self.dhuhrTIME, action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "")
        let ASSR_MI = NSMenuItem(title: self.assrTIME, action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "")
        let MAGHRIB_MI = NSMenuItem(title: self.maghribTIME, action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "")
        let ISHA_MI = NSMenuItem(title: self.ishaTIME, action: #selector(AppDelegate.loadSalahTime(_:)), keyEquivalent: "")
        
        DispatchQueue.main.sync{
            statusItem.menu?.addItem(NSMenuItem.separator())
            statusItem.menu?.addItem(FAJR_MI)
            statusItem.menu?.addItem(DHUHR_MI)
            statusItem.menu?.addItem(ASSR_MI)
            statusItem.menu?.addItem(MAGHRIB_MI)
            statusItem.menu?.addItem(ISHA_MI)
            
            statusItem.button?.title = "MAGHRIB 7:50"
        }
    }
    
    //    private func conmvertDataString(input: String) -> String {
    //        return input.filter({$0 != "%"})
    //    }
    
}
