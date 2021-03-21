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

    private let controller: GameController
    private let elementSize: CGSize

    init(gameController: GameController, elementSize: CGSize) {
        self.controller = gameController
        self.elementSize = elementSize
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
        
        controller.prepareMatrix()
        gameView?.updateContainerSize(grid: controller.grid, elementSize: elementSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gameView?.setup(grid: controller.grid, elementSize: elementSize)
        controller.start()
    }
}

extension GameViewController: GameViewOutput {
    func tapOnBtn(moveType: MoveTypes) {
        controller.handleMove(type: moveType)
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
    }
}

enum FigureColors: CaseIterable {
    case green, red, magenta, burberry, darkSea, purpleHaze, orange, summerGreen, blue, grassGreen

    func getUIColor() -> UIColor {
        guard let index = FigureColors.allCases.firstIndex(of: self) else { return .black }
        return FigureColors.colors[index]
    }

    static let colors = [#colorLiteral(red: 0.1490196078, green: 0.7607843137, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.5989651696, green: 0.2831991392, blue: 0.7236813406, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.7607843137, blue: 0.5490196078, alpha: 1)]
}
