//
//  NSColor+Extensions.swift
//  PixelApp
//
//  Created by Tom Hancocks on 03/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa


extension NSColor {
    
    // Produce an int32 encoded representation of the color.
    // 0x00RRGGBB
    func toUInt32() -> UInt32 {
        // We need to ensure that we first of all have the color in the RGB
        // color space so that we can extract the R, G and B components.
        let rgbColor = colorUsingColorSpaceName(NSDeviceRGBColorSpace)
        
        // Get the components and turn them into their byte representations
        let r = Int(rgbColor.redComponent * 255)
        let g = Int(rgbColor.greenComponent * 255)
        let b = Int(rgbColor.blueComponent * 255)
        let a = Int(rgbColor.alphaComponent * 255)
        
        // Compute the actual int32 encoded value, before returning it to the
        // caller
        var value: UInt32 = ((UInt32(a) & 0xFF) << 24)
        value |= ((UInt32(r) & 0xFF) << 16)
        value |= ((UInt32(g) & 0xFF) << 8)
        value |= (UInt32(b) & 0xFF)
        
        return value
    }
    
    
    // Create a new NSColor from an Int32 encoded representation of a color
    convenience init(encodedInt32Value value: UInt32) {
        
        let aRaw = Int((value >> 24) & 0xFF)
        let rRaw = Int((value >> 16) & 0xFF)
        let gRaw = Int((value >> 8) & 0xFF)
        let bRaw = Int((value >> 0) & 0xFF)
        
        let r: CGFloat = CGFloat(CGFloat(rRaw) / 255.0)
        let g: CGFloat = CGFloat(CGFloat(gRaw) / 255.0)
        let b: CGFloat = CGFloat(CGFloat(bRaw) / 255.0)
        let a: CGFloat = CGFloat(CGFloat(aRaw) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    // Produce an image preview of the color
    var previewImage: NSImage {
        get {
            let image = NSImage(size: NSSize(width: 64, height: 64))
            image.lockFocus()
            
            self.setFill()
            NSBezierPath(rect: NSRect(x: 0, y: 0, width: 64, height: 64)).fill()
            
            image.unlockFocus()
            return image
        }
    }
    
}
