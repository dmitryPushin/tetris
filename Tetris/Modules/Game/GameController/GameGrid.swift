//
//  GameGrid.swift
//  Tetris
//
//  Created by Dmitry Pushin on 01.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol GameGridInput {
    var rows: Int { get }
    var columns: Int { get }

    var middleColumn: Int { get }
}

struct GameGrid: GameGridInput {
    let rows: Int
    let columns: Int

    var middleColumn: Int {
        return columns / 2
    }

    init(rows: Int = 14, columns: Int = 9) {
        self.rows = rows
        self.columns = columns
    }
}
