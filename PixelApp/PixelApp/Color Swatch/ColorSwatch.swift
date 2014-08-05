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
    
    /// Instantiate the ColorSwatch with a selection of pre-determined colors
    override init() {
        colors.append(NSColor.blackColor())
        colors.append(NSColor.darkGrayColor())
        colors.append(NSColor.lightGrayColor())
        colors.append(NSColor.whiteColor())
        colors.append(NSColor.grayColor())
        colors.append(NSColor.redColor())
        colors.append(NSColor.greenColor())
        colors.append(NSColor.blueColor())
        colors.append(NSColor.cyanColor())
        colors.append(NSColor.yellowColor())
        colors.append(NSColor.magentaColor())
        colors.append(NSColor.orangeColor())
        colors.append(NSColor.purpleColor())
        colors.append(NSColor.brownColor())
        
        super.init()
    }
    
    /// Build a swatch using colors from an image
    init(colorsFromImageAtURL url: NSURL?) {
        if let actualURL = url? {
            // We need to keep a store of all the colors that we find that can be used
            // to ensure we don't get duplicates
            var colorSet = NSMutableSet()
            
            var error: NSError?
            let imageData = NSData(contentsOfURL: url,
                options: NSDataReadingOptions.DataReadingMappedIfSafe,
                error: &error)
            
            if let e = error? {
                println("\(e.localizedDescription)")
            }
            else {
                let bitmap = NSBitmapImageRep(data: imageData)
                
                // The coordinate system is actually flipped relative to how we actually see the image.
                // Correct this
                for y in 0..<Int(bitmap.size.height) {
                    for x in 0..<Int(bitmap.size.width) {
                        colorSet.addObject( NSNumber(unsignedInt: bitmap.colorAtX(x, y: y).toUInt32()) )
                    }
                }
                
                // Finally, step through the color set and actually create the colors
                for encodedColor in colorSet {
                    let color = NSColor(encodedInt32Value: (encodedColor as NSNumber).unsignedIntValue)
                    colors.append(color)
                }
            }
        }
        super.init()
    }
    
    /// Add a new color to the swatch
    func add(#color: NSColor) {
        colors.append(color)
    }
    
    /// Remove an existing color from the swatch
    func remove(colorAtIndex index: Int) {
        colors.removeAtIndex(index)
    }
    
    /// Remove all existing colors from the swatch
    func removeAll() {
        colors.removeAll(keepCapacity: false)
    }
    
    /// Get a specific color from the swatch
    func color(atIndex index: Int) -> NSColor? {
        if index < 0 || index >= countElements(colors) {
            return nil
        }
        return colors[index]
    }
    
}
