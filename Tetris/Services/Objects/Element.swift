//
//  Element.swift
//  Tetris
//
//  Created by Dmitry Pushin on 09/02/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import Foundation

enum ElementType: Int {
    case emptyField = 0
    case figure
    case extra
}

struct Element {
    var color: FigureColors?
    var type: ElementType!

    init(type: ElementType) {
        self.type = type
    }
    
    init(color: FigureColors? = nil, type: ElementType = .figure) {
        self.color = color
        self.type = type
    }
}
