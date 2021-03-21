//
//  GameView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameViewInput: class {
    var delegate: GameViewOutput? { get set }

    func updateContainerSize(grid: GameGridInput, elementSize: CGSize)
    func setup(grid: GameGridInput, elementSize: CGSize)
    func drawLayer(layer: GameLayer, objects: [IntermediateFigure])
}

protocol GameViewOutput: class {
    func tapOnBtn(moveType: MoveTypes)
}

class GameView: UIView {
    weak var delegate: GameViewOutput?

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerWidth: NSLayoutConstraint!
    @IBOutlet private weak var containerHeight: NSLayoutConstraint!

    private var grid: GameGridInput!
    private var elementSize: CGSize!
    private var gridView: SKView!
    private(set) var gridScene: SKScene!

    private var figureView: SKView!
    private(set) var figureScene: SKScene!

    private func prepareGridView() {
        gridView = SKView()
        gridView.clipView(to: containerView)
        gridScene = SKScene(size: CGSize(width: containerView.frame.width,
                                         height: containerView.frame.height))
        gridView.presentScene(gridScene)
    }

    private func prepareFigureView() {
        figureView = SKView()
        figureView.clipView(to: containerView)
        figureView.backgroundColor = .clear

        figureScene = SKScene(size: CGSize(width: containerView.frame.width,
                                           height: containerView.frame.height))
        figureScene.backgroundColor = .clear
        figureView.presentScene(figureScene)
    }

    func updateContainerSize(grid: GameGridInput, elementSize: CGSize) {
        containerWidth.constant = elementSize.height * CGFloat(grid.columns)
        containerHeight.constant = elementSize.width * CGFloat(grid.rows)
    }
}

extension GameView: GameViewInput {
    func setup(grid: GameGridInput, elementSize: CGSize) {
        self.grid = grid
        self.elementSize = elementSize

        prepareGridView()
        prepareFigureView()
    }

    func drawLayer(layer: GameLayer, objects: [IntermediateFigure]) {
        switch layer {
        case .figure:
            figureScene.removeAllChildren()
            objects.forEach { (obj) in
                let node = SKSpriteNode(color: obj.color?.getUIColor() ?? .white, size: elementSize)
                node.anchorPoint = .zero
                node.position = CGPoint(
                    x: elementSize.width * CGFloat(obj.position.column),
                    y: elementSize.height * CGFloat(grid.rows - obj.position.row - 1)
                )
                figureScene.addChild(node)
            }
        case .grid:
            gridScene.removeAllChildren()

            objects.forEach { (obj) in
                let path = IndexPath(row: obj.position.row, section: obj.position.column)
                let node = obj.getSpriteNode(for: path, elementSize: elementSize, rows: grid.rows)
                gridScene.addChild(node)
            }
        }
    }
}

extension GameView {
    @IBAction func tapLeft(_ sender: Any) {
        delegate?.tapOnBtn(moveType: .left)
    }

    @IBAction func tapRight(_ sender: Any) {
        delegate?.tapOnBtn(moveType: .right)
    }

    @IBAction func tapRotate(_ sender: Any) {
        delegate?.tapOnBtn(moveType: .rotate)
    }

    @IBAction func tapDown(_ sender: Any?) {
        delegate?.tapOnBtn(moveType: .down)
    }
}


private extension IntermediateFigure {
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
            let alphaComponent = CGFloat((indexPath.row * 1) + (indexPath.section * 1)) / 30.0
            return UIColor.blue.withAlphaComponent(alphaComponent)
        }
    }
}
