//
//  PaneActionBar.swift
//  PixelApp
//
//  Created by Tom Hancocks on 03/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class PaneActionBar: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let fillColor = NSColor.whiteColor()
        let borderColor = NSColor(calibratedWhite: 0.643, alpha: 1.0)
        
        borderColor.setFill()
        NSBezierPath(rect: bounds).fill()
        
        fillColor.setFill()
        NSBezierPath(rect: NSInsetRect(bounds, 0, 1)).fill()
    }
    
}
