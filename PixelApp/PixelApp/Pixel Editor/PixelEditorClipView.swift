//
//  PixelEditorClipView.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Cocoa

class PixelEditorClipView: NSClipView {

    var centersDocumentView: Bool = true
    
    override func constrainBoundsRect(proposedBounds: NSRect) -> NSRect {
        var constrainedClipViewBoundsRect: NSRect = super.constrainBoundsRect(proposedBounds)
        var documentViewFrameRect = documentView.frame
        
        if !self.centersDocumentView {
            return constrainedClipViewBoundsRect
        }
        
        var proposedWidth = CGRectGetWidth(constrainedClipViewBoundsRect)
        var proposedHeight = CGRectGetHeight(constrainedClipViewBoundsRect)
        var frameWidth = CGRectGetWidth(documentViewFrameRect)
        var frameHeight = CGRectGetHeight(documentViewFrameRect)
        
        if proposedWidth >= frameWidth {
            constrainedClipViewBoundsRect.origin.x = floor((proposedWidth - frameWidth) / -2.0)
        }
        
        if proposedHeight >= frameHeight {
            constrainedClipViewBoundsRect.origin.y = floor((proposedHeight - frameHeight) / -2.0)
        }
        
        return constrainedClipViewBoundsRect
    }
    
}
