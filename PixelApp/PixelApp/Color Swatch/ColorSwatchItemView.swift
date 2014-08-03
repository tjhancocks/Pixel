//
//  ColorSwatchItemView.swift
//  PixelApp
//
//  Created by Tom Hancocks on 03/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class ColorSwatchItemView: NSView {

    var selected: Bool = false {
        didSet {
            setNeedsDisplayInRect(bounds)
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if selected {
            NSColor.alternateSelectedControlColor().setFill()
            NSBezierPath(rect: bounds).fill()
        }
    }
    
}
