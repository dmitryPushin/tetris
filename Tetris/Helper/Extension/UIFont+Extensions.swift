//
//  UIFont+Extensions.swift
//  Tetris
//
//  Created by Dmitry Pushin on 21.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

enum FontTypeFace: String {
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
}

extension UIFont {
    static func appFont(size: CGFloat, type: FontTypeFace) -> UIFont {
        return UIFont(name: "TTNorms-\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
