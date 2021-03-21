//
//  GameController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol GameControllerInput {
    init(grid: GameGridInput)
    
    var grid: GameGridInput { get }
    var delegate: GameControllerOutput? { get set }

    func prepareMatrix()
    func start()
    func handleMove(type: MoveTypes)
}

enum GameLayer {
    case grid
    case figure
}

struct IntermediateFigure {
    let color: FigureColors?
    let position: Position
}

protocol GameControllerOutput: class {
    func update(layer: GameLayer, objects: [IntermediateFigure])
    func showAlert(title: String, message: String, action: @escaping () -> Void)
}

class GameController: GameControllerInput {
    var delegate: GameControllerOutput?

    private var matrix: MatrixController!

    private(set) var grid: GameGridInput
    private var repeatingTimer: RepeatingTimer?

    required init(grid: GameGridInput) {
        self.grid = grid
    }

    func prepareMatrix() {
        var figures = try? FigureFetcher.prepareFigures()
        figures = figures?.filter({ $0.type == .standard })
        
        let control = FigureHelper(figures: figures ?? [])
        matrix = MatrixController(grid: grid, control: control, delegate: self)
    }

    func start() {
        matrix.startNewGame()
        startTimer()
    }

    private func startTimer() {
        repeatingTimer = RepeatingTimer(interval: 0.5, handler: {
            DispatchQueue.main.async { [weak self] in
                self?.handleMove(type: .down)
            }
        })
        repeatingTimer?.resume()
    }

    func handleMove(type: MoveTypes) {
        matrix.moveFigure(moveType: type)
    }
}

extension GameController: MatrixListener {
    func onFinish() {
        repeatingTimer = nil
        delegate?.showAlert(title: "Игра завершена",
                            message: "Попробовать снова?",
                            action: { [unowned self] in
                                self.start()
                            })
    }

    func figureMoved(figure: Figure) {
        let obj = figure.positions.map({ IntermediateFigure(color: figure.color, position: $0) })
        delegate?.update(layer: .figure, objects:  obj)
    }

    func updateGrid(array: Array2D<Element>) {
        // TODO: ??
        var test = [IntermediateFigure]()

        for row in 0..<grid.rows {
            for column in 0..<grid.columns {
                guard let element = array[row, column] else { continue }
                switch element.type {
                case .figure:
                    test.append(IntermediateFigure(color: element.color, position: Position(row, column)))
                default:
                    test.append(IntermediateFigure(color: nil, position: Position(row, column)))
                }
            }
        }

        delegate?.update(layer: .grid, objects: test)
    }
}
