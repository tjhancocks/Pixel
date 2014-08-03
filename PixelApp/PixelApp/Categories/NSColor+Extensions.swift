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
        
        // Compute the actual int32 encoded value, before returning it to the
        // caller
        var value: UInt32 = ((UInt32(r) & 0xFF) << 16)
        value |= ((UInt32(g) & 0xFF) << 8)
        value |= (UInt32(b) & 0xFF)
        
        return value
    }
    
    
    // Create a new NSColor from an Int32 encoded representation of a color
    convenience init(encodedInt32Value value: UInt32) {
        let r: CGFloat = CGFloat(Int((value >> 16) & 0xFF) / 255)
        let g: CGFloat = CGFloat(Int((value >> 8) & 0xFF) / 255)
        let b: CGFloat = CGFloat(Int((value >> 0) & 0xFF) / 255)
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}
