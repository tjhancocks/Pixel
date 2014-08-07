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
    var size: CGSize = CGSizeZero {
        didSet {
            createNewDataBuffer()
        }
    }
    
    var layerRepresentation: NSImage?
    var opacity: CGFloat = 1.0
    var visibility = true
    
    
    // Instantiate a layer to be a certain size
    init(size: CGSize) {
        self.size = size
        createNewDataBuffer()
    }
    
    // Create a new data buffer for the layer pixel data
    func createNewDataBuffer() {
        layerRepresentation = NSImage(size: size)
    }
    
    
    // The rectangle representation of the layer (AppKit variant)
    var rect: NSRect {
        return NSRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    
    // Import data from an image at the specified URL and use it to fill in the pixel data for the layer.
    // This will crop the image to the size of the layer.
    func importPixelsFromImage(atURL url: NSURL) {
        var error: NSError?
        let imageData = NSData(contentsOfURL: url,
            options: NSDataReadingOptions.DataReadingMappedIfSafe,
            error: &error)
        
        if let e = error? {
            println("\(e.localizedDescription)")
            return
        }
        
        if let layer = layerRepresentation? {
            let importImage = NSImage(data: imageData)
            layer.lockFocus()
            
            // Keep track of the context's previous settings. We're going to be altering them temporarily so
            // that we can do a pixellated scale.
            let graphicsContext = NSGraphicsContext.currentContext()
            let wasAntialiasing = graphicsContext.shouldAntialias
            let previousImageInterpolation = graphicsContext.imageInterpolation
            graphicsContext.shouldAntialias = false
            graphicsContext.imageInterpolation = .None
            
            // Draw the new import image into the layer
            let importRect = NSRect(origin: CGPointZero, size: NSSizeToCGSize(importImage.size))
            importImage.drawInRect(rect, fromRect: importRect, operation: .CompositeSourceOver, fraction: 1.0)
            
            // Restore previous settings
            graphicsContext.shouldAntialias = wasAntialiasing
            graphicsContext.imageInterpolation = previousImageInterpolation
            
            
            layer.unlockFocus()
        }
        
    }
    
    
    // Update the specified pixel in the layer data and trigger a redraw of the layer
    // cached representation
    func setPixel(atPoint point: PixelPoint, toColor color: NSColor) {
        if let layer = layerRepresentation? {
            layer.lockFocus()
            
            color.setFill()
            NSBezierPath(rect: NSRect(x: point.x, y: point.y, width: 1, height: 1)).fill()
            
            layer.unlockFocus()
        }
    }
    
    //
    func drawCircle(atPoint point: PixelPoint, toColor color: NSColor, withRadius r: CGFloat, andSolid s: Bool) {
        if let layer = layerRepresentation? {
            layer.lockFocus()
            
            color.set()
            var rect = NSInsetRect(NSRect(x: point.x, y: point.y, width: 0, height: 0), -r, -r)
            
            if s {
                NSBezierPath(ovalInRect: rect).fill()
            }
            else {
                NSBezierPath(ovalInRect: rect).stroke()
            }
            
            layer.unlockFocus()
        }
    }
    
    
    // This will return NSColor.clearColor if there is no data for the pixel available.
    func pixelColor(atPoint point: PixelPoint) -> NSColor {
        if let layer = layerRepresentation? {
            // Grab a bitmap representation of the image and pull the color from it.
            let bitmap = NSBitmapImageRep(data: layer.TIFFRepresentation)
            return bitmap.colorAtX(point.x, y: point.y)
        }
        return NSColor.clearColor()
    }
    
}
