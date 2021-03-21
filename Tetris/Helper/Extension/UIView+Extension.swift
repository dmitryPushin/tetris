//
//  UIView+Extension.swift
//  Tetris
//
//  Created by Dmitry Pushin on 09/02/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T? {
        return Bundle
            .main
            .loadNibNamed((String(describing: self)), owner: nil, options: nil)?
            .first(where: { $0 is T }) as? T
    }
    
    func clipView(to superview: UIView) {
        superview.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)]
        )
    }
}
