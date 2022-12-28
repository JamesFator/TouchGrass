//
//  WindowView.swift
//  TouchGrass
//
//  Created by James Fator on 12/28/22.
//

import Cocoa
import AVFoundation

class WindowView: NSView {
    var audioPlayer: AVAudioPlayer?
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        // If the view is clicked, then toggle the audioPlayer state
        if audioPlayer != nil {
            if audioPlayer!.isPlaying {
                audioPlayer?.stop()
            } else {
                audioPlayer?.play()
            }
        }
    }
    
    override func updateLayer() {
        guard let layer = layer else { return }
        layer.backgroundColor = NSColor(red: 0x00/255, green: 0xb0/255, blue: 0xff/255, alpha: 1).cgColor
        
        // Play sound effects
        if audioPlayer == nil {
            if let asset = NSDataAsset(name:"forest"){
                do {
                    // Use NSDataAsset's data property to access the audio file stored in Sound.
                    audioPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                    // Loop indefinitely
                    audioPlayer?.numberOfLoops = -1
                    audioPlayer?.play()
               } catch let error as NSError {
                     NSLog(error.localizedDescription)
               }
            }
        }
    }
}
