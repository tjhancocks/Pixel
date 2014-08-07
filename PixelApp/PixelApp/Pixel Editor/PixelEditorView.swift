//
//  PixelEditorView.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class PixelEditorView: NSView {
    
    // Brush Settings
    var brushColor: NSColor = NSColor.blackColor()
    var brushSize: Int = 1
    
    
    // Canvas Settings
    var actualSize: CGSize = CGSize(width: 32, height: 32)
    private var scaledSize: CGSize {
        return CGSize(width: actualSize.width * currentScaleFactor,
            height: actualSize.height * currentScaleFactor)
    }
    
    var wantsPixelGrid: Bool = true {
        didSet {
            setNeedsDisplayInRect(bounds)
        }
    }
    
    var currentScaleFactor: CGFloat = 5 {
        didSet {
            frame = NSRect(origin: CGPointZero, size: scaledSize)
            setNeedsDisplayInRect(bounds)
        }
    }
    
    
    // Layer Settings
    var pixelLayers = [PixelLayer]()
    var activePixelLayer: Int = 0
    var layersTableView: NSTableView? {
        didSet {
            self.layersTableView?.setDataSource(self)
            self.layersTableView?.setDelegate(self)
            self.layersTableView?.reloadData()
        }
    }
    
    
    /// Instantiate a new editor view with the specified frame size and the actual pixel grid size
    init(frame frameRect: NSRect, withSize size: CGSize) {
        pixelLayers = [PixelLayer]()
        actualSize = size
        super.init(frame: frameRect)
        addPixelLayer()
    }
    
    required init(coder: NSCoder) {
        pixelLayers = [PixelLayer]()
        super.init(coder: coder)
        addPixelLayer()
    }
    
    
    /// Provides the actual on screen dimensions of a pixel as they are displayed within the canvas
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
        
        // Draw a flattened version of the image on the canvas
        flattenedImage(atScale: currentScaleFactor).drawInRect(bounds)
        
        // Draw the pixel grid lines if they are wanted
        if wantsPixelGrid {
            drawPixelGrid()
        }
    }
    
    func flattenedImage(atScale imageScale: CGFloat) -> NSImage {
        let imageScaledSize = NSSize(width: actualSize.width * imageScale, height: actualSize.height * imageScale)
        let image = NSImage(size: imageScaledSize)
        image.lockFocus()
        
        let graphicsContext = NSGraphicsContext.currentContext()
        let wasAntialiasing = graphicsContext.shouldAntialias
        let previousImageInterpolation = graphicsContext.imageInterpolation
        graphicsContext.shouldAntialias = false
        graphicsContext.imageInterpolation = .None
        
        // Draw each of the layers, starting with the backmost layer and working to the front most
        for pixelLayer in pixelLayers {
            // If the layer is not visible, then just skip to the next one
            if !pixelLayer.visibility {
                continue
            }
            
            if let rep = pixelLayer.layerRepresentation? {
                rep.drawInRect(NSRect(origin: CGPointZero, size: imageScaledSize),
                    fromRect: pixelLayer.rect,
                    operation: NSCompositingOperation.CompositeSourceOver,
                    fraction: pixelLayer.opacity)
            }
        }
        
        graphicsContext.shouldAntialias = wasAntialiasing
        graphicsContext.imageInterpolation = previousImageInterpolation
        
        image.unlockFocus()
        return image
    }
    
    
    override func mouseDown(theEvent: NSEvent!) {
        draw(locationInView: convertPoint(theEvent.locationInWindow, fromView: nil),
            usingRadius: CGFloat(brushSize))
    }
    
    override func mouseDragged(theEvent: NSEvent!) {
        draw(locationInView: convertPoint(theEvent.locationInWindow, fromView: nil),
            usingRadius: CGFloat(brushSize))
    }
    
    
    /// Draw a single point of color at the specified location. It takes an actual point in
    /// the view itself and then converts it to the actual that actual pixel space of the 
    /// final image.
    /// It will use the current brush settings.
    func drawPixel(locationInView point: CGPoint) {
        // Convert the point to the actual pixel grid
        let x = Int(floor(point.x / currentScaleFactor))
        let y = Int(floor(point.y / currentScaleFactor))
        
        // Get the active layer
        let activeLayer = pixelLayers[activePixelLayer]
        activeLayer.setPixel(atPoint: PixelPoint(x: x, y: y), toColor: brushColor)
        
        // Update the view
        setNeedsDisplayInRect(bounds)
    }
    
    ///
    func drawCircle(locationInView point: CGPoint, usingRadius r: CGFloat, withSolidFill solid: Bool) {
        // Convert the point to the actual pixel grid
        let x = Int(floor(point.x / currentScaleFactor))
        let y = Int(floor(point.y / currentScaleFactor))
        
        // Get the active layer
        let activeLayer = pixelLayers[activePixelLayer]
        activeLayer.drawCircle(atPoint: PixelPoint(x: x, y: y),
            toColor: brushColor,
            withRadius: (r / 2.0),
            andSolid: solid)
        
        // Update the view
        setNeedsDisplayInRect(bounds)
    }
    
    /// Draw at the specified point using the specified brush radius
    func draw(locationInView point: CGPoint, usingRadius r: CGFloat = 1.0) {
        // If the radius is 1 or less, then just draw a pixel. Nice and simple.
        // For values of r that are larger, then we will need to draw the pixels in the shape
        // of a solid circle.
        if r <= 1.0 {
            drawPixel(locationInView: point)
        }
        else {
            drawCircle(locationInView: point, usingRadius: r, withSolidFill: true)
        }
    }
    
    
    /// Add a new layer to the canvas, using the actual final pixel size and current scale
    /// factor.
    func addPixelLayer() {
        var pixelLayer = PixelLayer(size: actualSize)
        pixelLayers += [pixelLayer]
        layersTableView?.reloadData()
    }
    
    /// Remove the specified pixel layer. This will destroy any pixel information contained
    /// on that layer, and trigger a redraw of the canvas.
    func removePixelLayer(atIndex index: Int) {
        pixelLayers.removeAtIndex(index)
        setNeedsDisplayInRect(bounds)
        layersTableView?.reloadData()
    }
    
    /// Rename a specific pixel layer to the given name
    func setName(name: String, ofLayerAtIndex index: Int) {
        let pixelLayer = pixelLayers[index]
        pixelLayer.name = name
        layersTableView?.reloadData()
    }
    
    /// Change the opacity of a specific pixel layer to the given value
    func setOpacity(value: Double, ofLayerAtIndex index: Int) {
        pixelLayers[index].opacity = CGFloat(value)
        setNeedsDisplayInRect(bounds)
    }
    
    /// Load base image for layer using a given URL
    func setBaseImage(url: NSURL?, ofLayerAtIndex index: Int) {
        if let actualURL = url? {
            let pixelLayer = pixelLayers[index]
            pixelLayer.importPixelsFromImage(atURL: actualURL)
            setNeedsDisplayInRect(bounds)
        }
    }
    
    
    /// Draw grid lines representing the layout of pixels on the canvas. The grid lines are
    /// a standard grid line color. 
    /// This may need to be changed in future!
    func drawPixelGrid() {
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


/// This extension handles everything to do with the tableview displaying
/// layers, as well as any actions for creating, removing or selecting active
/// layers.
extension PixelEditorView: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int {
        return countElements(pixelLayers)
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
        let layer = pixelLayers[row]
        
        if tableColumn.identifier == "name" {
            return layer.name
        }
        else if tableColumn.identifier == "visibility" {
            return NSNumber(bool: layer.visibility)
        }
        
        return nil
    }
    
    func tableView(tableView: NSTableView!, setObjectValue object: AnyObject!, forTableColumn tableColumn: NSTableColumn!, row: Int) {
        
        let layer = pixelLayers[row]
        
        if tableColumn.identifier == "name" {
            layer.name = object as String
        }
        else if tableColumn.identifier == "visibility" {
            layer.visibility = (object as NSNumber).boolValue
            setNeedsDisplayInRect(bounds)
        }
    }
    
    
    
    func tableViewSelectionDidChange(notification: NSNotification!) {
        let tableView = notification.object as NSTableView
        if tableView == layersTableView {
            activePixelLayer = tableView.selectedRow
        }
    }
    
}
