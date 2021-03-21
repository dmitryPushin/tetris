//
//  FigureColors.swift
//  Tetris
//
//  Created by Dmitry Pushin on 19.07.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

enum FigureColors: CaseIterable {
    case green, red, magenta, burberry, darkSea, purpleHaze, orange, summerGreen, blue, grassGreen

    func getUIColor() -> UIColor {
        guard let index = FigureColors.allCases.firstIndex(of: self) else { return .black }
        return FigureColors.colors[index]
    }

    static let colors = [#colorLiteral(red: 0.1490196078, green: 0.7607843137, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.5989651696, green: 0.2831991392, blue: 0.7236813406, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.7607843137, blue: 0.5490196078, alpha: 1)]
}
