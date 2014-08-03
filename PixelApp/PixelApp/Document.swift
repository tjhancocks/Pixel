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
    var documentEditorView: PixelEditorView?
    
    @IBOutlet var layersTableView: NSTableView?
    
                            
    init() {
        super.init()
        // Add your subclass-specific initialization here.
                                    
    }

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
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func dataOfType(typeName: String?, error outError: NSErrorPointer) -> NSData? {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return nil
    }

    override func readFromData(data: NSData?, ofType typeName: String?, error outError: NSErrorPointer) -> Bool {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
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
    
}


