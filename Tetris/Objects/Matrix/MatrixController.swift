//
//  MatrixController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 06/02/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol MatrixListener {
    func onFinish()
    func updateCounter(result: Int)
    func figureMoved(figure: Figure)
    func updateGrid(array: Array2D<Element>)
}

protocol MatrixInput {
    init(grid: GameGridInput, control: FigureHelper, delegate: MatrixListener)

    func startNewGame()
    func moveFigure(moveType: MoveTypes)
}

final class MatrixController {
    private let grid: GameGridInput
    private let control: FigureHelperInput
    
    private var matrix: Array2D<Element>!
    private var currentFigure: Figure!
    private var delegate: MatrixListener?
    
    // MARK: - Life Cycle
    required init(grid: GameGridInput, control: FigureHelper, delegate: MatrixListener) {
        self.grid = grid
        self.delegate = delegate
        self.control = control
        self.matrix = getEmptyFieldMatrix()
    }

    // MARK: - Private
    private func addNewFigure() {
        currentFigure = control.generateFigure(startColumn: grid.middleColumn)
        let hasPossibleMove = calculateNewPositionsFor(move: .down, figure: &currentFigure) != nil

        if hasPossibleMove {
            delegate?.figureMoved(figure: currentFigure)
        } else {
            delegate?.onFinish()
        }
    }
    
    private func translateFigureIntoGrid(figure: Figure) {
        figure.positions.forEach { matrix[$0.row, $0.column] = Element(color: figure.color, type: .figure) }
        delegate?.updateGrid(array: matrix)
    }
    
    private func removeFilledRowsIfExists(matrix: Array2D<Element>) -> Array2D<Element> {
        let filledRowMatrixIndexes = matrix.elements.enumerated()
            .map { $0.element.contains(where: { $0?.type == ElementType.emptyField }) ? nil : $0.offset }
            .compactMap { $0 }

        guard !filledRowMatrixIndexes.isEmpty else { return matrix }

        var updatedGrid = getEmptyFieldMatrix()
        var row = grid.rows - 1
        var currentRow = grid.rows - 1
        while row >= 0 {
            if !filledRowMatrixIndexes.contains(row) {
                updatedGrid[currentRow] = matrix.elements[row]
                currentRow -= 1
            }
            row -= 1
        }
        delegate?.updateCounter(result: filledRowMatrixIndexes.count)
        return updatedGrid
    }
    
    // MARK: - Move
    private func possibleMoveFor(_ positions: [Position]) -> Bool {
        let intersectElement = positions.first(where: { element in
            let checkIntersections = matrix[element.row, element.column]?.type == .figure
            let checkBounds = element.row >= grid.rows || element.column < 0 || element.column >= grid.columns
            return checkIntersections || checkBounds
        })
        return intersectElement == nil
    }
    
    private func calculateNewPositionsFor(move: MoveTypes, figure: inout Figure) -> [Position]? {
        var positions = [Position]()
        switch move {
        case .down:
            positions = figure.positions.compactMap { Position($0.row + 1, $0.column) }
        case .left:
            positions = figure.positions.compactMap { Position($0.row, $0.column - 1) }
        case .right:
            positions = figure.positions.compactMap { Position($0.row, $0.column + 1) }
        case .rotate:
            positions = control.getRotatedPositionsFor(figure: figure)
            positions = getPositionShitedFromEdge(positions: positions)
        }
        return possibleMoveFor(positions) ? positions : nil
    }

    private func getPositionShitedFromEdge(positions: [Position]) -> [Position] {
        var updatedPositions = positions
        if positions.first(where: { $0.column < 0 }) != nil {
            // Move right
            updatedPositions = positions.map({ Position($0.row, $0.column + 1)})
            return getPositionShitedFromEdge(positions: updatedPositions)
        } else if positions.first(where: { $0.column >= grid.columns }) != nil {
            // move left
            updatedPositions = positions.map({ Position($0.row, $0.column - 1)})
            return getPositionShitedFromEdge(positions: updatedPositions)
        }
        return updatedPositions
    }

    private func getEmptyFieldMatrix() -> Array2D<Element> {
        var array = Array2D<Element>(columns: grid.columns, rows: grid.rows)
        array.fillWith(value: Element(type: .emptyField))
        return array
    }
}

extension MatrixController: MatrixInput {
    func startNewGame() {
        currentFigure = nil
        matrix = getEmptyFieldMatrix()
        delegate?.updateGrid(array: matrix)
        addNewFigure()
    }

    func moveFigure(moveType: MoveTypes) {
        let newPositions = calculateNewPositionsFor(move: moveType, figure: &currentFigure)

        if newPositions != nil {
            // set new angle for the current figure in case of rotation
            if case .rotate = moveType {
                currentFigure.angle = currentFigure.angle.next()
            }
            currentFigure.positions = newPositions
            delegate?.figureMoved(figure: currentFigure)
            return
        }

        if moveType == .down {
            translateFigureIntoGrid(figure: currentFigure)
            currentFigure = nil
            matrix = removeFilledRowsIfExists(matrix: matrix)
            delegate?.updateGrid(array: matrix)
            addNewFigure()
        }
    }
}
