//
//  SettingsViewController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 05.05.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

class FiguresViewController: UIViewController {
    override func loadView() {
        self.view = FiguresView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
