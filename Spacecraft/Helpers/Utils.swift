//
//  Utils.swift
//  Spacecraft
//
//  Created by Cassio Diego T. Campos on 01/07/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func vecAdd(_ a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    static func vecSub(_ a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    static func vecMult(_ a: CGPoint, b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x * b, y: a.y * b)
    }
    
    static func vecLength(_ a: CGPoint) -> CGFloat {
        return CGFloat(sqrtf(CFloat(a.x)*CFloat(a.x)+CFloat(a.y)*CFloat(a.y)))
    }
    
    static func vecNormalize(_ a: CGPoint) -> CGPoint {
        let length: CGFloat = vecLength(a)
        return CGPoint(x: a.x / length, y: a.y / length)
    }
    
    static func alreadyExistDataForKey(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
