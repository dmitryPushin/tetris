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

    func startGame()
    func pauseGame()
    func prepareMatrix()
    func handleMove(type: MoveTypes)
    func forceTimer(needForce: Bool)
}

enum GameLayer {
    case grid
    case figure
}

protocol GameControllerOutput: AnyObject {
    func update(counter: Int)
    func update(layer: GameLayer, objects: [IntermediateFigure])
    func showAlert(title: String, message: String, action: @escaping () -> Void)
}

class GameController {
    var delegate: GameControllerOutput?

    private var matrix: MatrixController!

    private(set) var grid: GameGridInput
    private var repeatingTimer: RepeatingTimer?

    // TODO: Move to separate structure or game info class
    private var counter: Int = 0
    private var defaultTimerSpeed = 0.5
    private var forceTimerSpeed = 0.05

    required init(grid: GameGridInput) {
        self.grid = grid
    }

    private func startTimer(interval: Double) {
        repeatingTimer = RepeatingTimer(interval: interval, handler: {
            DispatchQueue.main.async { [weak self] in
                self?.handleMove(type: .down)
            }
        })
        repeatingTimer?.resume()
    }
}

extension GameController: GameControllerInput {
    func forceTimer(needForce: Bool) {
        if needForce {
            pauseGame()
            startTimer(interval: forceTimerSpeed)
        } else {
            pauseGame()
            startTimer(interval: defaultTimerSpeed)
        }
    }

    func handleMove(type: MoveTypes) {
        matrix.moveFigure(moveType: type)
    }

    func prepareMatrix() {
        var figures = try? FigureFetcher.prepareFigures()
        figures = figures?.filter({ $0.type == .standard })

        let control = FigureHelper(figures: figures ?? [])
        matrix = MatrixController(grid: grid, control: control, delegate: self)
    }

    func startGame() {
        matrix.startNewGame()
        startTimer(interval: defaultTimerSpeed)
        delegate?.update(counter: counter)
    }

    func pauseGame() {
        repeatingTimer = nil
        // TODO: Save state
    }
}

extension GameController: MatrixListener {
    func updateCounter(result: Int) {
        counter += result
        delegate?.update(counter: counter)
    }

    func onFinish() {
        repeatingTimer = nil
        delegate?.showAlert(title: "Игра завершена",
                            message: "Попробовать снова?",
                            action: { [unowned self] in
                                self.startGame()
                            })
    }

    func figureMoved(figure: Figure) {
        let obj = figure.positions.map({ IntermediateFigure(color: figure.color, position: $0) })
        delegate?.update(layer: .figure, objects:  obj)
    }

    func updateGrid(array: Array2D<Element>) {
        var viewModels = [IntermediateFigure]()

        for row in 0..<grid.rows {
            for column in 0..<grid.columns {
                guard let element = array[row, column] else { continue }
                let figure = IntermediateFigure(color: element.type! == .figure ? element.color : nil,
                                                position: Position(row, column))
                viewModels.append(figure)
            }
        }

        delegate?.update(layer: .grid, objects: viewModels)

        pauseGame()
        startTimer(interval: defaultTimerSpeed)
    }
}
