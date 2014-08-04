//
//  NewDocumentController.swift
//  PixelApp
//
//  Created by Tom Hancocks on 03/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class NewDocumentController: NSWindowController {

    var parentWindow: NSWindow?
    
    @IBOutlet var documentNameField: NSTextField?
    @IBOutlet var baseImageNameField: NSTextField?
    @IBOutlet var canvasWidthField: NSTextField?
    @IBOutlet var canvasHeightField: NSTextField?
    
    var baseImageURL: NSURL?
    var canvasSize = CGSize(width: 16, height: 16)
    var documentName = "My Pixel Art Image"
    
    
    override var windowNibName: String! {
        return "NewDocumentController"
    }
    
    override func windowDidLoad()  {
        super.windowDidLoad()
        
        documentNameField!.stringValue = documentName
        canvasWidthField!.integerValue = Int(canvasSize.width)
        canvasHeightField!.integerValue = Int(canvasSize.height)
    }
    
    
    @IBAction func importBaseImage(sender: AnyObject!) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = NSImage.imageFileTypes()
        openPanel.prompt = "Import"
        
        if openPanel.runModal() == NSOKButton {
            baseImageURL = openPanel.URL
            baseImageNameField!.stringValue = baseImageURL!.lastPathComponent.stringByDeletingPathExtension
            
            // Pull in the actual image and then get its dimensions and set them.
            let image = NSImage(contentsOfURL: openPanel.URL)
            canvasWidthField!.integerValue = Int(image.size.width)
            canvasHeightField!.integerValue = Int(image.size.height)
        }
    }
    
    @IBAction func validateCanvasSizeInput(sender: AnyObject!) {
        let field = sender as NSTextField
        
        if field.integerValue < 1 {
            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            alert.messageText = "Invalid Canvas Size"
            alert.informativeText = "A canvas can not have a dimension that is less than 1 pixel."
            alert.alertStyle = .WarningAlertStyle
            
            if alert.runModal() == NSOKButton {
                field.integerValue = 1
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        if let parent = parentWindow? {
            parent.endSheet(window, returnCode: NSCancelButton)
        }
        window.orderOut(sender)
    }
    
    @IBAction func createDocument(sender: AnyObject!) {
        documentName = documentNameField!.stringValue
        canvasSize.width = CGFloat(canvasWidthField!.integerValue)
        canvasSize.height = CGFloat(canvasHeightField!.integerValue)
        
        if let parent = parentWindow? {
            parent.endSheet(window, returnCode: NSOKButton)
        }
        window.orderOut(sender)
    }
}
