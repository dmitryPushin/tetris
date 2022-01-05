//
//  FigureHelper.swift
//  Tetris
//
//  Created by Dmitry Pushin on 21.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol FigureHelperInput {
    init(figures: [DBFigureModel], configuration: GameConfiguration)

    func generateFigure(startColumn: Int) -> Figure
    func getRotatedPositionsFor(figure: Figure) -> [Position]
}

private struct PositionBounds {
    var minRowIndex: Int?
    var minColumnIndex: Int?
}

final class FigureHelper {
    private let figureModels: [DBFigureModel]

    required init(figures: [DBFigureModel], configuration: GameConfiguration) {
        if configuration.useDefaultFigures {
            self.figureModels = figures.filter { $0.type == .standard }
        } else {
            self.figureModels = figures
        }
    }
}

extension FigureHelper: FigureHelperInput {
    func generateFigure(startColumn: Int) -> Figure {
        let model = figureModels.randomElement()!
        return Figure(figureModel: model, startColumn: startColumn)
    }

    func getRotatedPositionsFor(figure: Figure) -> [Position] {
        guard let mappedPositions = positionTranslatedIntoDBFigureStructure(figure: figure),
              let rotatedPositions = mappedPositions.rotated(angle: .degrees_90) else { return figure.positions }

        let coord = getMinimalBoundsFor(positions: mappedPositions)

        let elements = rotatedPositions.elements
            .enumerated()
            .map { (value) in
                value.element.enumerated().map {
                    $0.element != nil ? Position(coord.minRowIndex! + value.offset, coord.minColumnIndex! + $0.offset) : nil
                }
            }
            .reduce([], +)
            .compactMap { $0 }
        return elements
    }

    private func positionTranslatedIntoDBFigureStructure(figure: Figure) -> Array2D<Position>? {
        guard let dbFigure = figureModels.first(where: { $0.id == figure.figureId }),
              let structure = dbFigure.structure.rotated(angle: figure.angle) else {
            return nil
        }

        var mappedPositions = Array2D<Position>(columns: structure.columns, rows: structure.rows)

        var positions = figure.positions
        structure.elements.enumerated().forEach { (rowIndex, row) in
            mappedPositions[rowIndex] = row.map { $0 == DBFigureModelField.filled.rawValue ? positions?.removeFirst() : nil }
        }
        return mappedPositions
    }

    // TODO: convert to high level function
    private func getMinimalBoundsFor(positions: Array2D<Position>) -> PositionBounds {
        var coord = PositionBounds()

        positions.elements.enumerated().forEach { (x, row) in
            row.enumerated().forEach({ (y, element) in
                if let element = element {
                    if coord.minRowIndex == nil {
                        coord.minRowIndex = element.row - x
                    }

                    if coord.minColumnIndex == nil {
                        coord.minColumnIndex = element.column - y
                    }
                }
            })
        }
        return coord
    }
}
