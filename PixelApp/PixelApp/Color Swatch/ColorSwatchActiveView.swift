//
//  ColorSwatchActiveView.swift
//  PixelApp
//
//  Created by Tom Hancocks on 04/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class ColorSwatchActiveView: NSView {

    var color: NSColor = NSColor.blackColor() {
        didSet {
            setNeedsDisplayInRect(bounds)
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        color.setFill()
        NSBezierPath(roundedRect: bounds, xRadius: 5, yRadius: 5).fill()
    }
    
}
