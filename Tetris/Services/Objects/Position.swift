//
//  Position.swift
//  Tetris
//
//  Created by Dmitry Pushin on 02.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

struct Position: Comparable {
    var row: Int
    var column: Int

    init(_ row: Int,
         _ column: Int) {
        self.row = row
        self.column = column
    }

    func description() -> String {
        return "\(row):\(column)"
    }

    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }

    static func < (lhs: Position, rhs: Position) -> Bool {
        return (lhs.row <= rhs.row && lhs.column < rhs.column) || (lhs.row < rhs.row)
    }

    static func > (lhs: Position, rhs: Position) -> Bool {
        return (lhs.row >= rhs.row && lhs.column > rhs.column) || (lhs.row > rhs.row)
    }
}
