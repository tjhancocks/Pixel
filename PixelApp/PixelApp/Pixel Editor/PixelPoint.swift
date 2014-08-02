//
//  PixelPoint.swift
//  PixelApp
//
//  Created by Tom Hancocks on 02/08/2014.
//  Copyright (c) 2014 Tom Hancocks. All rights reserved.
//

import Foundation

// The Pixel Point structure is used to help reference specific points on a layer.
struct PixelPoint: Hashable {
    var x: UInt = 0
    var y: UInt = 0
    
    var hashValue: Int {
        return "(\(x),\(y))".hashValue
    }
    
    var toCGPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}


func == (lhs: PixelPoint, rhs: PixelPoint) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

func != (lhs: PixelPoint, rhs: PixelPoint) -> Bool {
    return !(lhs == rhs)
}