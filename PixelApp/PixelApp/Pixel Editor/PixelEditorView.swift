//
//  PixelEditorView.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class PixelEditorView: NSView {
    
    var brushColor: NSColor = NSColor.blackColor()
    var actualSize: CGSize = CGSize(width: 32, height: 32)
    var wantsGridLines = true
    var pixelLayers = [PixelLayer]()
    var activePixelLayer: Int = 0
    var currentScaleFactor: CGFloat = 10
    
    
    init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addPixelLayer()
    }
    
    
    var cellSize: CGSize {
        return CGSize(width: frame.size.width / actualSize.width, height: frame.size.height / actualSize.height)
    }
    

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Draw the edge and background color for the canvas
        NSColor.gridColor().setFill()
        NSBezierPath(rect: bounds).fill()
        
        NSColor.whiteColor().setFill()
        NSBezierPath(rect: NSInsetRect(bounds, 1, 1)).fill()
        
        // Draw each of the layers, starting with the backmost layer and working to the front most
        for pixelLayer in pixelLayers {
            if let rep = pixelLayer.cachedRepresentation? {
                rep.drawAtPoint(NSZeroPoint, fromRect:
                    pixelLayer.rect,
                    operation: .CompositeSourceOver,
                    fraction: 1.0)
            }
        }
        
        // Draw the grid lines if they are wanted
        if wantsGridLines {
            for y in 1..<Int(actualSize.height) {
                NSColor.gridColor().setFill()
                
                var origin = CGPoint(x: 0, y: CGFloat(y) * cellSize.height)
                var size = CGSize(width: CGRectGetWidth(frame), height: 1)
                
                NSBezierPath(rect: NSRect(origin: origin, size: size)).fill()
            }
            
            for x in 1..<Int(actualSize.width) {
                NSColor.gridColor().setFill()
                
                var origin = CGPoint(x: CGFloat(x) * cellSize.width, y: 0)
                var size = CGSize(width: 1, height: CGRectGetHeight(frame))
                
                NSBezierPath(rect: NSRect(origin: origin, size: size)).fill()
            }
        }
    }
    
    
    
    override func mouseDown(theEvent: NSEvent!) {
        drawPixel(locationInView: convertPoint(theEvent.locationInWindow, fromView: nil))
    }
    
    override func mouseDragged(theEvent: NSEvent!) {
        drawPixel(locationInView: convertPoint(theEvent.locationInWindow, fromView: nil))
    }
    
    func drawPixel(locationInView point: CGPoint) {
        // Convert the point to the actual pixel grid
        let x = UInt(floor(point.x / currentScaleFactor))
        let y = UInt(floor(point.y / currentScaleFactor))
        
        // Get the active layer
        let activeLayer = pixelLayers[activePixelLayer]
        activeLayer.setPixel(atPoint: PixelPoint(x: x, y: y), toColor: brushColor)
        
        // Update the view
        setNeedsDisplayInRect(bounds)
    }
    
    
    func addPixelLayer() {
        var pixelLayer = PixelLayer()
        pixelLayer.size = actualSize
        pixelLayer.scaleFactor = currentScaleFactor
        pixelLayers += pixelLayer
    }
}
