//
//  PixelEditorLayer.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa


class PixelLayer {
    
    var name: String = "Untitled Layer"
    var size: CGSize = CGSizeZero
    var data = [PixelPoint:NSColor]()
    var cachedRepresentation: NSImage?
    private var currentScaleFactor: CGFloat = 1.0
    
    init() {
        
    }
    
    // When setting the scale factor, we must also update the cached representation of the
    // layer
    var scaleFactor: CGFloat = 1.0 {
        didSet {
            updateCache()
        }
    }
    
    // Calculate the layer size based on the current scale factor
    var scaledSize: CGSize {
        get {
            return CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        }
    }
    
    // The rectangle representation of the layer (AppKit variant)
    var rect: NSRect {
        get {
            return NSRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height)
        }
    }
    
    // Update the specified pixel in the layer data and trigger a redraw of the layer
    // cached representation
    func setPixel(atPoint point: PixelPoint, toColor color: NSColor) {
        data[point] = color
        updateCache()
    }
    
    // This will return NSColor.clearColor if there is no data for the pixel available.
    func pixelColor(atPoint point: PixelPoint) -> NSColor {
        if let color = data[point]? {
            return color
        }
        return NSColor.clearColor()
    }
    
    
    // Update the cachedRepresentation of the layer
    func updateCache() {
        var layer = NSImage(size: NSSizeFromCGSize(scaledSize))
        layer.lockFocus()
        
        for y in 0..<UInt(size.height) {
            for x in 0..<UInt(size.width) {
                let color = pixelColor(atPoint: PixelPoint(x: x, y: y))
                let pixelLocation = CGPoint(x: CGFloat(x) * scaleFactor, y: CGFloat(y) * scaleFactor)
                let pixelSize = CGSize(width: scaleFactor, height: scaleFactor)
                
                color.setFill()
                NSBezierPath(rect: CGRect(origin: pixelLocation, size: pixelSize)).fill()
            }
        }
        
        layer.unlockFocus()
        cachedRepresentation = layer
    }
    
}
