//
//  Document.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    // New Document Sheet
    var newDocumentSheet: NewDocumentController?
    
    // Main Editor Area
    var documentEditorView: PixelEditorView?
    @IBOutlet var documentScrollView: NSScrollView?
    @IBOutlet var pixelGridButton: NSButton?
    @IBOutlet var scaleSlider: NSSlider?
    @IBOutlet var scaleLabel: NSTextField?
    
    // Layers Pane
    @IBOutlet var layersTableView: NSTableView?
    @IBOutlet var layerOpacitySlider: NSSlider?
    @IBOutlet var layerBlendModePopup: NSPopUpButton?
    
    // Brush Settings Pane
    @IBOutlet var brushSize: NSTextField?
    @IBOutlet var toolSelection: NSSegmentedControl?
    @IBOutlet var solidShapeButton: NSButton?
    
    // Colors Palette Pane
    @IBOutlet var colorPalettePane: NSCollectionView?
    var colorSwatch = ColorSwatch()
    

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        dispatch_after(500000, dispatch_get_main_queue()) {
            self.newDocumentSheet = NewDocumentController()
            self.newDocumentSheet!.parentWindow = aController.window
            aController.window.beginSheet(self.newDocumentSheet!.window) {
                (response) -> Void in
                
                if response == NSOKButton {
                    self.createEditorCanvasView(name: self.newDocumentSheet!.documentName,
                        ofSize: self.newDocumentSheet!.canvasSize,
                        atScale: 5.0,
                        withBaseImageURL: self.newDocumentSheet!.baseImageURL)
                }
                else {
                    aController.close()
                }
            }
        }
        
        
        // Make sure the color palette is selectable, and set up an observe for
        // its selection
        colorPalettePane!.selectable = true
        colorPalettePane!.allowsMultipleSelection = false
        colorPalettePane!.addObserver(self,
            forKeyPath: "selectionIndexes",
            options: NSKeyValueObservingOptions.New,
            context: nil)
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String {
        return "Document"
    }

    override func dataOfType(typeName: String?, error outError: NSErrorPointer) -> NSData? {
        outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return nil
    }

    override func readFromData(data: NSData?, ofType typeName: String?, error outError: NSErrorPointer) -> Bool {
        outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return false
    }
    
    
    /// Create a new canvas at the specified size and scale
    func createEditorCanvasView(#name: String, ofSize size: CGSize, atScale scale: CGFloat, withBaseImageURL url: NSURL?) {
        var canvasFrame = NSRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        documentEditorView = PixelEditorView(frame: canvasFrame, withSize: size)
        documentScrollView!.documentView = documentEditorView!
        documentEditorView!.layersTableView = layersTableView
        documentEditorView!.setName(name: name, ofLayerAtIndex: 0)
        documentEditorView!.setBaseImage(url, ofLayerAtIndex: 0)
        documentEditorView!.currentScaleFactor = scale
        
        if let actualURL = url? {
            colorSwatch = ColorSwatch(colorsFromImageAtURL: actualURL)
        }
    }
    
    
    /// Action to add a new layer to the editor
    @IBAction func addLayer(sender: AnyObject!) {
        documentEditorView!.addPixelLayer()
    }
    
    /// Action to remove the currently selected layer from the editor
    @IBAction func removeLayer(sender: AnyObject!) {
        documentEditorView!.removePixelLayer(atIndex: documentEditorView!.activePixelLayer)
    }
    
    
    /// Toggle the Pixel Grid on the canvas
    @IBAction func togglePixelGrid(sender: AnyObject!) {
        documentEditorView!.wantsPixelGrid = ((sender as NSButton).state == NSOnState)
    }
    
    /// Change the scale of the canvas
    @IBAction func updateCanvasScale(sender: AnyObject!) {
        documentEditorView!.currentScaleFactor = CGFloat((sender as NSSlider).doubleValue)
        scaleLabel!.doubleValue = (sender as NSSlider).doubleValue
    }
    
    
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        
        // Listen for any changes to the selection of the color palette
        if (object as NSCollectionView) == colorPalettePane && keyPath == "selectionIndexes" {
            let selectedIndex = (change["new"] as NSIndexSet).firstIndex
            if let color = colorSwatch.color(atIndex: selectedIndex)? {
                documentEditorView!.brushColor = color
            }
        }
        
    }
}


