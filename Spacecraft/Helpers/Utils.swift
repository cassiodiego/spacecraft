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
    
    static func setupLetterpress() -> [NSAttributedString.Key: NSObject] {
        return [NSAttributedString.Key.foregroundColor: Constants.UI.spacecraftBlue,
                NSAttributedString.Key.font: UIFont(name: Constants.Fonts.pressStart, size: 24)!,
                NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString]
    }
    
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { return UIColor.gray }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension UIView {
    func blink() {
         self.alpha = 0.2
         UIView.animate(withDuration: 1,
                        delay: 0.0,
                        options: [.curveLinear, .repeat, .autoreverse],
                        animations: {self.alpha = 1.0},
                        completion: nil)
     }
}
