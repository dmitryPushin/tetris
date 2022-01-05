//
//  SettingsViewController.swift
//  Tetris
//
//  Created by Dmitry Pushin on 05.01.2022.
//  Copyright © 2022 Dmitry Pushin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func loadView() {
        let view = SettingsView()
        view.delegate = self
        view.backgroundColor = .backgroundColor
        self.view = view
    }
}

extension SettingsViewController: SettingsViewOutput {
    func tapOnBackBtn() {
        navigationController?.popViewController(animated: true)
    }
}
