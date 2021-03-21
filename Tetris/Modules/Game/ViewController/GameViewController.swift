//
//  GameViewController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 26/10/2018.
//  Copyright © 2018 Dmitry Pushin. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    private var gameView: GameView?

    private let controller: GameControllerInput

    init(gameController: GameControllerInput) {
        self.controller = gameController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let mainView = GameView.loadFromNib() as? GameView
        mainView?.delegate = self
        self.gameView = mainView
        self.view = mainView ?? UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        controller.prepareMatrix()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gameView?.setup(grid: controller.grid)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        controller.startGame()
    }
}

extension GameViewController: GameViewOutput {
    func tapOnBtn(moveType: MoveTypes) {
        controller.handleMove(type: moveType)
    }

    func back() {
        controller.pauseGame()
        navigationController?.popViewController(animated: true)
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
            gameView?.cancelGestureHandling()
        default:
            break
        }
    }

    func update(counter: Int) {
        gameView?.updateScore(count: counter)
    }

    func handleLongTap(isInProgress: Bool) {
        if isInProgress {
            controller.forceTimer(needForce: true)
        } else {
            controller.forceTimer(needForce: false)
        }
    }
}
