//
//  PanelControlView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.07.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

protocol PanelControlInput {
    func cancelLongTapGesture()
}

protocol PanelControlOutput: AnyObject {
    func handleMove(type: MoveTypes)
    func getButtonSideSize() -> CGFloat
    func handleLongTap(type: MoveTypes, isInProgress: Bool)
}

final class PanelControlView: UIView {
    private weak var output: PanelControlOutput?
    private var longTapActiveBtn: UIButton?

    init(output: PanelControlOutput) {
        self.output = output
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        prepareConstraints()
        addLongTapGestures()
    }

    private func prepareConstraints() {
        let leftBtn = createButton(type: .left)
        let rightBtn = createButton(type: .right)
        let downBtn = createButton(type: .down)
        let rotateBtn = createButton(type: .rotate)

        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(rotateBtn)
        addSubview(downBtn)

        let size = output?.getButtonSideSize() ?? .zero

        NSLayoutConstraint.activate([
            leftBtn.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftBtn.topAnchor.constraint(equalTo: topAnchor),
            leftBtn.heightAnchor.constraint(equalToConstant: size),
            leftBtn.widthAnchor.constraint(equalToConstant: size),

            rightBtn.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightBtn.topAnchor.constraint(equalTo: topAnchor),
            rightBtn.heightAnchor.constraint(equalToConstant: size),
            rightBtn.widthAnchor.constraint(equalToConstant: size),

            rotateBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            rotateBtn.topAnchor.constraint(equalTo: topAnchor),
            rotateBtn.heightAnchor.constraint(equalToConstant: size),
            rotateBtn.widthAnchor.constraint(equalToConstant: size),

            downBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            downBtn.bottomAnchor.constraint(equalTo: bottomAnchor),
            downBtn.heightAnchor.constraint(equalToConstant: size),
            downBtn.widthAnchor.constraint(equalToConstant: size)
        ])
    }

    private func addLongTapGestures() {
        subviews
            .filter { $0 is UIButton }
            .forEach { view in
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
                (view as? UIButton)?.addGestureRecognizer(longPress)
            }
    }

    @objc
    private func handleTap(sender: UIButton) {
        guard let type = MoveTypes.init(rawValue: sender.tag) else {
            fatalError("Can't handle unrecognized move type")
        }
        output?.handleMove(type: type)
    }

    @objc
    private func longTap(sender: UILongPressGestureRecognizer) {
        guard let tag = sender.view?.tag,
              let btn = sender.view as? UIButton,
              let type = MoveTypes.init(rawValue: tag) else {
            fatalError("Can't handle unrecognized move type")
        }

        switch sender.state {
        case .began:
            longTapActiveBtn = btn
            output?.handleLongTap(type: type, isInProgress: true)
        case .failed, .cancelled, .ended:
            longTapActiveBtn = btn
            output?.handleLongTap(type: type, isInProgress: false)
        default:
            break
        }
    }
}

extension PanelControlView: PanelControlInput {
    func cancelLongTapGesture() {
        guard let btn = longTapActiveBtn else { return }

        let gesture = btn.gestureRecognizers?.first(where: { $0 is UILongPressGestureRecognizer })
        gesture?.isEnabled = false
        gesture?.isEnabled = true
        longTapActiveBtn = nil
    }
}

extension PanelControlView {
    private func createButton(type: MoveTypes) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = type.rawValue
        button.backgroundColor = .containerColor
        button.layer.cornerRadius = 6
        button.tintColor = .btnTintColor
        button.setImage(imageFor(type: type), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTap(sender:)), for: .touchUpInside)
        return button
    }

    private func imageFor(type: MoveTypes) -> UIImage? {
        switch type {
        case .left:
            return UIImage(named: "left_icon")
        case .right:
            return UIImage(named: "right_icon")
        case .down:
            return UIImage(named: "back_icon")
        case .rotate:
            return UIImage(named: "rotate_icon")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
