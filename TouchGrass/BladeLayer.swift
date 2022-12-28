//
//  BladeLayer.swift
//  TouchGrass
//
//  Created by James Fator on 12/28/22.
//

import Cocoa

class BladeLayer: CALayer {
    
    var idealPosition: Double = 0.0
    var force: Double = 0.0
    
    func updateIdealPosition(x: Double) {
        idealPosition += x
    }
    
    func applyForce(x: Double) {
        force = x
    }
    
    func movePosition() {
        self.position.x = idealPosition + force
        force = force * 0.9
        if abs(force) < 0.1 {
            force = 0
        }
    }
}
