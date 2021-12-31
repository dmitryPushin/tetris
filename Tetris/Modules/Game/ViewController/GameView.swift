//
//  GameView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameViewInput: AnyObject {
    var delegate: GameViewOutput? { get set }

    // TODO: Think about it
    func cancelGestureHandling()

    func updateScore(count: Int)
    func setup(grid: GameGridInput)
    func drawLayer(layer: GameLayer, objects: [IntermediateFigure])
}

protocol GameViewOutput: AnyObject {
    func back()
    func handleLongTap(isInProgress: Bool)
    func tapOnBtn(moveType: MoveTypes)
}

private struct Layout {
    let elementSize = CGSize(width: 30, height: 30)
}

class GameView: UIView {
    weak var delegate: GameViewOutput?

    @IBOutlet private weak var leftBtn: UIButton!
    @IBOutlet private weak var rightBtn: UIButton!
    @IBOutlet private weak var downBtn: UIButton!
    @IBOutlet private weak var rotateBtn: UIButton!
    @IBOutlet private weak var backBtn: UIButton!

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerWidth: NSLayoutConstraint!
    @IBOutlet private weak var containerHeight: NSLayoutConstraint!

    private let layout = Layout()
    private var grid: GameGridInput!
    private var elementSize: CGSize!
    private var gridView: SKView!
    private(set) var gridScene: SKScene!

    private var figureView: SKView!
    private(set) var figureScene: SKScene!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .backgroundColor
        containerView.backgroundColor = .containerColor
        containerView.layer.cornerRadius = 6
        configureButtons()
        configureTitles()
    }

    private func configureTitles() {
        [scoreLabel, counterLabel].forEach { (label) in
            label?.font = .appFont(size: 17, type: .regular)
            label?.textColor = .btnTintColor
        }
    }

    private func configureButtons() {
        let views = [leftBtn, rightBtn, downBtn, rotateBtn].compactMap { $0 }
        views.forEach { (btn) in
            btn.backgroundColor = .containerColor
            btn.layer.cornerRadius = 6
            btn.tintColor = .btnTintColor

            btn.layer.shadowColor = UIColor.btnTintColor.withAlphaComponent(0.3).cgColor
            btn.layer.shadowOpacity = 5
            btn.layer.shadowOffset = .zero
            btn.layer.shadowRadius = 3
        }

        leftBtn.setImage(#imageLiteral(resourceName: "left_icon"), for: .normal)
        rightBtn.setImage(#imageLiteral(resourceName: "right_icon"), for: .normal)
        downBtn.setImage(#imageLiteral(resourceName: "back_icon"), for: .normal)
        rotateBtn.setImage(#imageLiteral(resourceName: "baseline_rotate_right_black_18dp").withRenderingMode(.alwaysTemplate), for: .normal)

        backBtn.backgroundColor = .containerColor
        backBtn.layer.cornerRadius = backBtn.frame.width * 0.5
        backBtn.tintColor = .btnTintColor

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        downBtn.addGestureRecognizer(longPress)
    }

    @objc private func longTap(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            delegate?.handleLongTap(isInProgress: true)
        case .failed, .cancelled, .ended:
            delegate?.handleLongTap(isInProgress: false)
        default:
            break
        }
    }

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
}

extension GameView: GameViewInput {
    func setup(grid: GameGridInput) {
        self.grid = grid

        prepareGridView()
        prepareFigureView()

        containerWidth.constant = layout.elementSize.height * CGFloat(grid.columns)
        containerHeight.constant = layout.elementSize.width * CGFloat(grid.rows)
    }

    func updateScore(count: Int) {
        counterLabel.text = "\(count)"
    }

    func cancelGestureHandling() {
        let gesture = downBtn.gestureRecognizers?.first(where: { $0 is UILongPressGestureRecognizer })
        gesture?.isEnabled = false
        gesture?.isEnabled = true
    }

    func drawLayer(layer: GameLayer, objects: [IntermediateFigure]) {
        switch layer {
        case .figure:

            figureScene.removeAllChildren()
            objects.forEach { (obj) in
                let node = SKSpriteNode(color: obj.color?.getUIColor() ?? .white, size: layout.elementSize)
                node.anchorPoint = .zero
                node.position = CGPoint(
                    x: layout.elementSize.width * CGFloat(obj.position.column),
                    y: layout.elementSize.height * CGFloat(grid.rows - obj.position.row - 1)
                )
                figureScene.addChild(node)
            }
        case .grid:
            gridScene.removeAllChildren()

            objects.forEach { (obj) in
                let path = IndexPath(row: obj.position.row, section: obj.position.column)
                let node = obj.getSpriteNode(for: path, elementSize: layout.elementSize, rows: grid.rows)
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

    @IBAction func tapBack(_ sender: Any?) {
        delegate?.back()
    }
}
