//
//  GrassView.swift
//  TouchGrass
//
//  Created by James Fator on 12/28/22.
//

import Cocoa

class GrassView: NSView {
    
    var blades: [BladeLayer] = []
    var bladeAssets: [String] = ["blade1","blade2","blade3","blade4","blade5"]
    
    var lastLocation: NSPoint?
    
    // This is to keep the current tracking touch (figure).
    // NSTouchBar supports multiple touches, but since it has only 30-point height,
    // it is reasonable to only track one touch.
    var trackingTouchIdentity: AnyObject?
    
    // Marked as dynamic for this property to support KVO.
    @objc dynamic var trackingLocationString = ""
    
    // NSView by default doesn't accept first responder, so override this to allow it.
    override var acceptsFirstResponder: Bool { return true }
    
    override func touchesBegan(with event: NSEvent) {
        // trackingTouchIdentity != nil:
        // You're already tracking a touch, so ignore this new touch.
        if trackingTouchIdentity == nil {
            if let touch = event.touches(matching: .began, in: self).first, touch.type == .direct {
                trackingTouchIdentity = touch.identity
                let location = touch.location(in: self)
                trackingLocationString = String(format: NSLocalizedString("Began At", comment: ""), location.x)
                lastLocation = location
            }
        }
        super.touchesBegan(with: event)
    }
    
    override func touchesMoved(with event: NSEvent) {
        if let trackingTouchIdentity = trackingTouchIdentity {
            let relevantTouches = event.touches(matching: .moved, in: self)
            let actualTouches = relevantTouches.filter({ $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity) })
            if let trackingTouch = actualTouches.first {
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: NSLocalizedString("Moved At", comment: ""), location.x)
                var force = 0.0
                if location.x > lastLocation!.x {
                    force = 10.0
                } else {
                    force = -10.0
                }
                for bladeIndex in 0...blades.count - 1 {
                    if bladeIndex % 5 == 0 {
                        continue
                    }
                    if blades[bladeIndex].idealPosition > location.x - 10 && blades[bladeIndex].idealPosition < location.x + 10 {
                        blades[bladeIndex].applyForce(x: force)
                    }
                }
                lastLocation = location
            }
        }
        super.touchesMoved(with: event)
    }
    
    override func touchesEnded(with event: NSEvent) {
        if let trackingTouchIdentity = trackingTouchIdentity {
            let relevantTouches = event.touches(matching: .ended, in: self)
            let actualTouches = relevantTouches.filter({ $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity) })
            if let trackingTouch = actualTouches.first {
                self.trackingTouchIdentity = nil
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: NSLocalizedString("Ended At", comment: ""), location.x)
                lastLocation = nil
            }
        }
        super.touchesEnded(with: event)
    }
    
    override func touchesCancelled(with event: NSEvent) {
        if let trackingTouchIdentity = trackingTouchIdentity {
            let relevantTouches = event.touches(matching: .cancelled, in: self)
            let actualTouches = relevantTouches.filter({ $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity) })
            if let trackingTouch = actualTouches.first {
                self.trackingTouchIdentity = nil
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: NSLocalizedString("Cancelled At", comment: ""), location.x)
                
                // The system is cancelling the touch, so roll back to the status before touchBegan.
                //...
            }
        }
        super.touchesCancelled(with: event)
    }
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    override func updateLayer() {
        guard let layer = layer else { return }
        layer.backgroundColor = NSColor(red: 0x00/255, green: 0xb0/255, blue: 0xff/255, alpha: 1).cgColor
        
        if blades.count > 0 {
            return // We've already drawn the blades. They'll update in separate thread.
        }
        
        // Generate initial blades of grass at random locations
        for _ in 1...800 {
            let blade = BladeLayer()
            blade.contentsGravity = .resizeAspect

            // Randomly choose a blade image
            blade.contents = NSImage(named: bladeAssets[Int.random(in: 0..<5)])
            
            // Set the starting point and note it's ideal positon so it doesn't deveate too far
            let startingPos = Int.random(in: -20..<700)
            blade.frame = CGRect(x: startingPos, y: 0, width: 10, height: 20)
            blade.updateIdealPosition(x: Double(startingPos))
            layer.addSublayer(blade)
            blades.append(blade)
        }
        
        // Queue up the first update
        DispatchQueue.main.asyncAfter(deadline:.now()+0.05) {
            self.updateBlades(t: 0)
        }
    }
    
    func updateBlades(t: CGFloat) {
        for bladeIndex in 0...blades.count - 1 {
            // Sine waves make the blades move back and forth smoothly
            // Separate the blades into two groups that move at different speeds
            if bladeIndex % 2 == 0 {
                blades[bladeIndex].updateIdealPosition(x: sin(t) * 0.2)
            } else {
                blades[bladeIndex].updateIdealPosition(x: sin(t) * 0.3)
            }
            blades[bladeIndex].movePosition()
        }
        
        // Queue up the next update
        DispatchQueue.main.asyncAfter(deadline:.now()+0.05) {
            self.updateBlades(t: t + 0.1)
        }
    }
}
