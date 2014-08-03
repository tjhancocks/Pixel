//
//  ColorSwatch.swift
//  PixelApp
//
//  Created by Tom Hancocks on 03/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa


class ColorSwatch: NSObject {
    
    var colors = [NSColor]()
    
    init() {
        colors += NSColor.blackColor()
        colors += NSColor.darkGrayColor()
        colors += NSColor.lightGrayColor()
        colors += NSColor.whiteColor()
        colors += NSColor.grayColor()
        colors += NSColor.redColor()
        colors += NSColor.greenColor()
        colors += NSColor.blueColor()
        colors += NSColor.cyanColor()
        colors += NSColor.yellowColor()
        colors += NSColor.magentaColor()
        colors += NSColor.orangeColor()
        colors += NSColor.purpleColor()
        colors += NSColor.brownColor()
    }
    
    func add(#color: NSColor) {
        colors += color
    }
    
    func remove(colorAtIndex index: Int) {
        colors.removeAtIndex(index)
    }
    
    func color(atIndex index: Int) -> NSColor? {
        if index < 0 || index >= countElements(colors) {
            return nil
        }
        return colors[index]
    }
    
}
