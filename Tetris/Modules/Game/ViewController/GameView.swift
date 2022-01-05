//
//  GameView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

protocol GameViewInput: AnyObject {
    var delegate: GameViewOutput? { get set }

    func cancelLongTapGesture()
    func updateScore(count: Int)
    func setup(grid: GameGridInput)
    func drawLayer(layer: GameLayer, objects: [IntermediateFigure])
}

protocol GameViewOutput: AnyObject {
    func tapOnBackBtn()
    func tapOnBtn(moveType: MoveTypes)
    func longTapOnBtn(moveType: MoveTypes, isInProgress: Bool)
}

private struct Layout {
    static let backButtonLeading: CGFloat = 25
    static let backButtonSize: CGFloat = 30

    static let containerViewBottom: CGFloat = 20

    static let panelControlWidth: CGFloat = 270
    static let panelControlBottom: CGFloat = 20
    static let panelControlBtnSideSize: CGFloat = {
        if UIScreen.main.bounds.width == 375 {
            return 35.0
        } else {
            return 45.0
        }
    }()
}

final class GameView: UIView {
    weak var delegate: GameViewOutput?

    private var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "left_icon"), for: .normal)
        btn.backgroundColor = .containerColor
        btn.tintColor = .btnTintColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = (Layout.backButtonSize * 0.5).rounded(.down)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(tapBack(_:)), for: .touchUpInside)
        return btn
    }()

    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score:"
        label.textColor = .btnTintColor
        label.font = .appFont(size: 14, type: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var counterLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .btnTintColor
        label.font = .appFont(size: 17, type: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var gridView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var figuresView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var panelControlView: (UIView & PanelControlInput)!
    private var grid: GameGridInput!
    private var elementSize: CGSize = .zero
    private var gridViewWidth: NSLayoutConstraint?
    private var gridViewHeight: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .backgroundColor

        panelControlView = PanelControlView(output: self)
        panelControlView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backBtn)
        addSubview(panelControlView)
        addSubview(containerView)
        addSubview(counterLabel)
        addSubview(scoreLabel)

        containerView.addSubview(gridView)
        containerView.addSubview(figuresView)
        gridViewWidth = gridView.widthAnchor.constraint(equalToConstant: .zero)
        gridViewHeight = gridView.heightAnchor.constraint(equalToConstant: .zero)

        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: Layout.backButtonSize),
            backBtn.heightAnchor.constraint(equalToConstant: Layout.backButtonSize),
            backBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Layout.backButtonLeading),
            backBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.backButtonLeading),

            panelControlView.widthAnchor.constraint(equalToConstant: Layout.panelControlWidth),
            panelControlView.heightAnchor.constraint(equalToConstant: Layout.panelControlBtnSideSize * 3),
            panelControlView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Layout.panelControlBottom),
            panelControlView.centerXAnchor.constraint(equalTo: centerXAnchor),

            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            containerView.bottomAnchor.constraint(equalTo: panelControlView.topAnchor, constant: -Layout.containerViewBottom),
            containerView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: Layout.containerViewBottom),

            gridView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            gridView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gridViewWidth!,
            gridViewHeight!,

            figuresView.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
            figuresView.topAnchor.constraint(equalTo: gridView.topAnchor),
            figuresView.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            figuresView.bottomAnchor.constraint(equalTo: gridView.bottomAnchor),

            scoreLabel.topAnchor.constraint(equalTo: backBtn.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.backButtonLeading),
            counterLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor),
            counterLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxElements: CGFloat = CGFloat(max(grid.columns, grid.rows))
        let size = (containerView.frame.height / maxElements).rounded(.down)
        elementSize = CGSize(width: size, height: size)
        gridViewWidth?.constant = (elementSize.width * CGFloat(grid.columns)).rounded(.down)
        gridViewHeight?.constant = (elementSize.height * CGFloat(grid.rows)).rounded(.down)
    }

    @objc
    func tapBack(_ sender: Any?) {
        delegate?.tapOnBackBtn()
    }
}

extension GameView: GameViewInput {
    func setup(grid: GameGridInput) {
        self.grid = grid
    }

    func updateScore(count: Int) {
        counterLabel.text = "\(count)"
    }

    func cancelLongTapGesture() {
        panelControlView.cancelLongTapGesture()
    }

    func drawLayer(layer: GameLayer, objects: [IntermediateFigure]) {
        let view = layer == .grid ? gridView : figuresView

        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        objects.forEach { obj in
            let rect = CGRect(x: elementSize.width * CGFloat(obj.position.column),
                              y: elementSize.height * CGFloat(obj.position.row),
                              width: elementSize.width,
                              height: elementSize.height)
            let figureView = UIView(frame: rect)
            figureView.backgroundColor = obj.color?.getUIColor() ?? .white
            figureView.layer.borderWidth = 0.2
            figureView.layer.borderColor = UIColor.black.cgColor
            view.addSubview(figureView)
        }
    }
}

extension GameView: PanelControlOutput {
    func getButtonSideSize() -> CGFloat {
        return Layout.panelControlBtnSideSize
    }

    func handleMove(type: MoveTypes) {
        delegate?.tapOnBtn(moveType: type)
    }

    func handleLongTap(type: MoveTypes, isInProgress: Bool) {
        delegate?.longTapOnBtn(moveType: type, isInProgress: isInProgress)
    }
}
