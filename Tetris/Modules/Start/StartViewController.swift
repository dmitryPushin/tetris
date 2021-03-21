//
//  StartViewController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 21.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    var router: BaseRouterInput!

    override func loadView() {
        let view = StartView(delegate: self)
        view.backgroundColor = .backgroundColor
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        router = BaseRouter()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension StartViewController: StartViewOutput {
    func startGame() {
        let vc = router.getGameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func openSettings() {
        let vc = router.getFigureViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
