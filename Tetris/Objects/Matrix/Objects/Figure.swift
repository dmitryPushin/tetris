//
//  BaseFigure.swift
//  Tetris
//
//  Created by Dmitry Pushin on 07/02/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import Foundation

class Figure {
    let figureId: String
    var angle: RotationAngle = .degrees_0
    var positions: [Position]!
    var color: FigureColors = FigureColors.allCases.randomElement()!

    required init(figureId: String, positions: [Position]) {
        self.figureId = figureId
        self.positions = positions
    }

    convenience init(figureModel: DBFigureModel, startColumn: Int) {
        let elements = figureModel.structure.elements
        let startRow = -elements.count

        let positions = elements.enumerated()
            .map { (row) in
                row.element.enumerated().map {
                    $0.element == DBFigureModelField.filled.rawValue ? Position(startRow + row.offset, startColumn + $0.offset) : nil
                }
            }
            .reduce([], +)
            .compactMap { $0 }

        self.init(figureId: figureModel.id, positions: positions)
    }
}
