//
//  Document.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    @IBOutlet var documentScrollView: NSScrollView?
    
    // Main Editor Area
    var documentEditorView: PixelEditorView?
    @IBOutlet var pixelGridButton: NSButton?
    
    // Layers Pane
    @IBOutlet var layersTableView: NSTableView?
    
    // Brush Settings Pane
    @IBOutlet var brushSize: NSTextField?
    @IBOutlet var toolSelection: NSSegmentedControl?
    @IBOutlet var solidShapeButton: NSButton?
    
    // Colors Palette Pane
    @IBOutlet var colorPalettePane: NSCollectionView?
    

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
                                    
        // Create a new editor view for the document, and add it to the scroll view
        documentEditorView = PixelEditorView(frame: NSRect(x: 0, y: 0, width: 320, height: 320))
        documentScrollView!.documentView = documentEditorView!
        documentEditorView!.layersTableView = layersTableView
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
    
}


