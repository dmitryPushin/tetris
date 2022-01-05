//
//  GameController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol GameControllerInput {
    init(grid: GameGridInput, configuration: GameConfiguration)
    
    var grid: GameGridInput { get }
    var delegate: GameControllerOutput? { get set }

    func startGame()
    func pauseGame()
    func prepareMatrix()
    func handleMove(type: MoveTypes)
    func forceSpeedForMove(type: MoveTypes, needForce: Bool)
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
    private(set) var configuration: GameConfiguration

    private var repeatingTimer: RepeatingTimer?
    private var forcedMoveRepeatingTimer: RepeatingTimer?
    private var counter: Int = 0

    required init(grid: GameGridInput, configuration: GameConfiguration) {
        self.grid = grid
        self.configuration = configuration
    }

    private func startTimer(interval: Double, forcedMoveType: MoveTypes?) {
        let timer = RepeatingTimer(interval: interval, handler: {
            DispatchQueue.main.async { [weak self] in
                self?.handleMove(type: forcedMoveType ?? .down)
            }
        })
        timer.resume()
        if forcedMoveType != nil {
            forcedMoveRepeatingTimer = timer
        } else {
            repeatingTimer = timer
        }
    }
}

extension GameController: GameControllerInput {
    func forceSpeedForMove(type: MoveTypes, needForce: Bool) {
        pauseGame()
        if needForce {
            switch type {
            case .rotate:
                startTimer(interval: configuration.rotateForceTimerSpeed, forcedMoveType: type)
            default:
                startTimer(interval: configuration.forceTimerSpeed, forcedMoveType: type)
            }
        }
        startTimer(interval: configuration.defaultTimerSpeed, forcedMoveType: nil)
    }

    func handleMove(type: MoveTypes) {
        matrix.moveFigure(moveType: type)
    }

    func prepareMatrix() {
        do {
            let figures = try FigureFetcher.prepareFigures()
            let control = FigureHelper(figures: figures, configuration: configuration)
            matrix = MatrixController(grid: grid, control: control, delegate: self)
        } catch {
            fatalError("There are no available figures")
        }
    }

    func startGame() {
        matrix.startNewGame()
        startTimer(interval: configuration.defaultTimerSpeed, forcedMoveType: nil)
        delegate?.update(counter: counter)
    }

    func pauseGame() {
        repeatingTimer = nil
        forcedMoveRepeatingTimer = nil
        // TODO: Save state
    }
}

extension GameController: MatrixListener {
    func updateCounter(result: Int) {
        counter += result
        delegate?.update(counter: counter)
    }

    func onFinish() {
        pauseGame()
        delegate?.showAlert(title: "The game is over",
                            message: "You scored - \(counter). Once again?",
                            action: { [unowned self] in
            self.counter = 0
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
                let figure = IntermediateFigure(
                    color: element.type! == .figure ? element.color : nil,
                    position: Position(row, column)
                )
                viewModels.append(figure)
            }
        }

        delegate?.update(layer: .grid, objects: viewModels)

        pauseGame()
        startTimer(interval: configuration.defaultTimerSpeed, forcedMoveType: nil)
    }
}
