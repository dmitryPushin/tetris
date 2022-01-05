//
//  GameViewController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 26/10/2018.
//  Copyright © 2018 Dmitry Pushin. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    private var gameView: GameView? {
        view as? GameView
    }

    private let gameController: GameControllerInput

    init(gameController: GameControllerInput) {
        self.gameController = gameController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let mainView = GameView(frame: .zero)
        mainView.delegate = self
        view = mainView
        gameView?.setup(grid: gameController.grid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        gameController.prepareMatrix()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        gameController.startGame()
    }
}

extension GameViewController: GameViewOutput {
    func tapOnBackBtn() {
        gameController.pauseGame()
        navigationController?.popViewController(animated: true)
    }

    func longTapOnBtn(moveType: MoveTypes, isInProgress: Bool) {
        gameController.forceSpeedForMove(type: moveType, needForce: isInProgress)
    }

    func tapOnBtn(moveType: MoveTypes) {
        gameController.handleMove(type: moveType)
    }
}

extension GameViewController: GameControllerOutput {
    func showAlert(title: String, message: String, action: @escaping () -> Void) {
        let action = UIAlertAction(
            title: "ОК",
            style: .default,
            handler: { _ in
                action()
            })
        showAlertViewWith(
            title: title,
            message: message,
            actions: [action]
        )
    }

    func update(layer: GameLayer, objects: [IntermediateFigure]) {
        gameView?.drawLayer(layer: layer, objects: objects)

        // Workaround for cancel long tap pressure
        switch layer {
        case .grid:
            gameView?.cancelLongTapGesture()
        default:
            break
        }
    }

    func update(counter: Int) {
        gameView?.updateScore(count: counter)
    }
}
