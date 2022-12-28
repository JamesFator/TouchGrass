//
//  ViewController.swift
//  TouchGrass
//
//  Created by James Fator on 12/28/22.
//

import Cocoa

class WindowController: NSWindowController {
    
}

extension WindowController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [NSTouchBarItem.Identifier("jamesfator.TouchGrass.touchBar")]
        
        return touchBar
    }
    
    // The system calls this while constructing the NSTouchBar for each NSTouchBarItem you want to create.
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let canvasView = GrassView()
        canvasView.allowedTouchTypes = .direct
        
        let custom = NSCustomTouchBarItem(identifier: identifier)
        custom.view = canvasView
        
        return custom
    }
    
}

