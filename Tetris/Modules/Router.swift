//
//  Router.swift
//  Tetris
//
//  Created by Dmitry Pushin on 21.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

protocol BaseRouterInput {
    func getRootViewController() -> UINavigationController
    func getGameViewController() -> UIViewController
    func getFigureViewController() -> UIViewController
    func getSettingsViewController() -> UIViewController
}

struct BaseRouter: BaseRouterInput {
    func getRootViewController() -> UINavigationController {
        return UINavigationController(rootViewController: StartViewController())
    }

    func getGameViewController() -> UIViewController {
        let gameController = GameController(
            grid: GameGrid(),
            configuration: GameConfiguration(useDefaultFigures: true)
        )

        let vc = GameViewController(gameController: gameController)
        gameController.delegate = vc
        return vc
    }

    func getSettingsViewController() -> UIViewController {
        SettingsViewController()
    }

    func getFigureViewController() -> UIViewController {
        FiguresViewController()
    }
}
