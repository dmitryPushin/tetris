//
//  UIViewContoller+Extension.swift
//  Tetris
//
//  Created by Dmitry Pushin on 09/02/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertViewWith(title: String,
                           message: String?,
                           actions: [UIAlertAction]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}
