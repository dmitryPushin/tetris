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
    
    private var elements: Array2D<Element>!
    private var currentFigure: Figure!
    private var delegate: MatrixListener?
    
    // MARK: - Life Cycle
    required init(grid: GameGridInput, control: FigureHelper, delegate: MatrixListener) {
        self.grid = grid
        self.delegate = delegate
        self.control = control
        self.elements = getDefaultElementsArray()
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
        figure.positions.forEach { elements[$0.row, $0.column] = Element(color: figure.color, type: .figure) }
        delegate?.updateGrid(array: elements)
    }
    
    private func removeFilledRowsIfExists(elements: Array2D<Element>) -> Array2D<Element> {
        var updatedGrid = getDefaultElementsArray()
        
        var row = grid.rows - 1
        var moveNextRowDown: Int = 0
        while row >= 0 {
            if elements[row]?.first(where: { $0?.type == ElementType.emptyField }) != nil {
                updatedGrid[row + moveNextRowDown] = elements[row]
                row -= 1
                continue
            }
            row -= 1
            moveNextRowDown += 1
        }
        return updatedGrid
    }
    
    // MARK: - Move
    private func possibleMoveFor(_ positions: [Position]) -> Bool {
        let intersectElement = positions.first(where: { element in
            let checkIntersections = elements[element.row, element.column]?.type == .figure
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

    private func getDefaultElementsArray() -> Array2D<Element> {
        var array = Array2D<Element>(columns: grid.columns, rows: grid.rows)
        array.fillWith(value: Element(type: .emptyField))
        return array
    }
}

extension MatrixController: MatrixInput {
    func startNewGame() {
        currentFigure = nil
        elements = getDefaultElementsArray()
        delegate?.updateGrid(array: elements)
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
            elements = removeFilledRowsIfExists(elements: elements)
            delegate?.updateGrid(array: elements)
            addNewFigure()
        }
    }
}
