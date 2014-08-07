//
//  NSImage+Extensions.swift
//  PixelApp
//
//  Created by Tom Hancocks on 07/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

extension NSImage {
    
    // Produce a bitmap representation of the image that is unscaled for retina screens.
    // Solution to this was found at 
    // http://stackoverflow.com/questions/23258596/how-to-save-png-file-from-nsimage-retina-issues-the-right-way
    // Thanks tad!
    // For some reason when making an NSBitmapImageRep from a CGImageRef or the data of an NSImage
    // it insists on applying its own scale, thus doubling the size of anything exported on a retina Mac.
    func unscaledBitmapImageRep() -> NSBitmapImageRep {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSDeviceRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0)
        
        rep.size = size
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: rep))
        
        drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0)
        
        NSGraphicsContext.restoreGraphicsState()
        return rep
    }
    
}
