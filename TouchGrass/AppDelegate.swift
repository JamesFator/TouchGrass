//
//  AppDelegate.swift
//  TouchGrass
//
//  Created by James Fator on 12/28/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

