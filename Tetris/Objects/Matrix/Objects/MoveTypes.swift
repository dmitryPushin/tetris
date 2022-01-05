//
//  MoveTypes.swift
//  Tetris
//
//  Created by Dmitry Pushin on 02.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

enum MoveTypes: Int, CaseIterable {
    case down = 0
    case left
    case right
    case rotate
}
