//
//  IntermediateFigure.swift
//  Tetris
//
//  Created by Dmitry Pushin on 19.07.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import SpriteKit

struct IntermediateFigure {
    let color: FigureColors?
    let position: Position
}

extension IntermediateFigure {
    func getSpriteNode(for path: IndexPath, elementSize: CGSize, rows: Int) -> SKSpriteNode {
        let color = fillColor(from: path)
        let node = SKSpriteNode(color: color, size: elementSize)
        node.anchorPoint = .zero
        node.position = CGPoint(
            x: elementSize.width * CGFloat(path.section),
            y: elementSize.height * CGFloat(rows - path.row - 1)
        )
        return node
    }

    private func fillColor(from indexPath: IndexPath) -> UIColor {
        if let color = self.color {
            return color.getUIColor()
        } else {
            return UIColor.containerColor
        }
    }
}
