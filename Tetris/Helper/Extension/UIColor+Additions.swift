//
//  UIColor+Additions.swift
//  Staffing
//
//  Created by Dmitry Pushin on 13.06.2018.
//  Copyright © 2018 Dmitry Pushin. All rights reserved.
//

import UIKit

extension UIColor {
    static let undefined: UIColor = rgbColor(r: 0, g: 0, b: 0)
    
    static func rgbColor(r: CGFloat,
                         g: CGFloat,
                         b: CGFloat,
                         a: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: a
        )
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        var colorString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if colorString.hasPrefix("#") {
            colorString.remove(at: colorString.startIndex)
        }
        
        if colorString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
