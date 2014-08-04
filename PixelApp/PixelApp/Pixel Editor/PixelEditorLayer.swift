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
    var data = [UInt32]()
    var cachedRepresentation: NSImage?
    private var currentScaleFactor: CGFloat = 1.0
    var opacity: CGFloat = 1.0
    
    
    // Instantiate a layer to be a certain size
    init(size: CGSize) {
        self.size = size
        createNewDataBuffer()
    }
    
    // Create a new data buffer for the layer pixel data
    func createNewDataBuffer() {
        self.data = [UInt32](count: Int(size.width) * Int(size.height), repeatedValue: UInt32.max)
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
        return CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
    }
    
    // The rectangle representation of the layer (AppKit variant)
    var rect: NSRect {
        return NSRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height)
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
        
        let bitmap = NSBitmapImageRep(data: imageData)
        
        // The coordinate system is actually flipped relative to how we actually see the image.
        // Correct this
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                if let i = index(forPixelPoint: PixelPoint(x: x, y: y))? {
                    data[i] = bitmap.colorAtX(x, y: Int(size.height) - y - 1).toUInt32()
                }
            }
        }
        
        updateCache()
    }
    
    
    // Calculate the index for a PixelPoint
    func index(forPixelPoint point: PixelPoint) -> Int? {
        if point.x < 0 || point.y < 0 || point.x >= Int(size.width) || point.y >= Int(size.height) {
            return nil
        }
        return Int( point.y * Int(size.width) + point.x )
    }
    
    // Calculate the PixelPoint for a given index
    func pixelPoint(forIndex index: Int) -> PixelPoint? {
        if index < 0 || index >= countElements(data) {
            return nil
        }
        
        let x = Int(countElements(data) % Int(size.width))
        let y = Int(countElements(data) / Int(size.height))
        
        return PixelPoint(x: x, y: y)
    }
    
    
    // Update the specified pixel in the layer data and trigger a redraw of the layer
    // cached representation
    func setPixel(atPoint point: PixelPoint, toColor color: NSColor) {
        if let i = index(forPixelPoint: point)? {
            data[i] = color.toUInt32()
            updateCache()
        }
    }
    
    // This will return NSColor.clearColor if there is no data for the pixel available.
    func pixelColor(atPoint point: PixelPoint) -> NSColor {
        if let i = index(forPixelPoint: point)? {
            if data[i] != UInt32.max {
                return NSColor(encodedInt32Value: data[i])
            }
        }
        return NSColor.clearColor()
    }
    
    
    // Update the cachedRepresentation of the layer
    func updateCache() {
        var layer = NSImage(size: NSSizeFromCGSize(scaledSize))
        layer.lockFocus()
        
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                let color = pixelColor(atPoint: PixelPoint(x: x, y: y))
                let pixelLocation = CGPoint(x: floor(CGFloat(x) * scaleFactor), y: floor(CGFloat(y) * scaleFactor))
                let pixelSize = CGSize(width: ceil(scaleFactor), height: ceil(scaleFactor))
                
                color.setFill()
                NSBezierPath(rect: CGRect(origin: pixelLocation, size: pixelSize)).fill()
            }
        }
        
        layer.unlockFocus()
        cachedRepresentation = layer
    }
    
}
