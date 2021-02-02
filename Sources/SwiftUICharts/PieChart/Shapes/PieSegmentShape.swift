//
//  PieSegmentShape.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

internal struct PieSegmentShape: Shape, Identifiable {
    
    var id          : UUID
    var startAngle  : Double
    var amount      : Double
    
    internal func path(in rect: CGRect) -> Path {
        
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        var path = Path()
        path.move(to: center)
        path.addRelativeArc(center      : center,
                            radius      : radius,
                            startAngle  : Angle(radians: startAngle),
                            delta       : Angle(radians: amount))
        
        return path
    }
}


internal struct DoughnutSegmentShape: InsettableShape, Identifiable {
    
    var id          : UUID
    var startAngle  : Double
    var amount      : Double
    var insetAmount : CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    internal func path(in rect: CGRect) -> Path {
        
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        var path = Path()
        
        path.addRelativeArc(center      : center,
                            radius      : radius - insetAmount,
                            startAngle  : Angle(radians: startAngle),
                            delta       : Angle(radians: amount))
        
        return path
    }
}
