//
//  StartView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 21.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import UIKit

protocol StartViewOutput: class {
    func startGame()
    func openSettings()
}

class StartView: UIView {
    private weak var delegate: StartViewOutput?

    private lazy var startGameBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Start game", for: .normal)
        btn.setTitleColor(.btnTintColor, for: .normal)
        btn.titleLabel?.font = UIFont.appFont(size: 24, type: .medium)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(handleStartGameBtnTap), for: .touchUpInside)
        return btn
    }()

    private lazy var settingsBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Figures", for: .normal)
        btn.setTitleColor(.btnTintColor, for: .normal)
        btn.titleLabel?.font = UIFont.appFont(size: 24, type: .medium)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(handleSettingsBtnTap), for: .touchUpInside)
        return btn
    }()

    init(delegate: StartViewOutput) {
        self.delegate = delegate
        super.init(frame: .zero)
        prepareSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareSubviews() {
        addSubview(startGameBtn)
        addSubview(settingsBtn)

        NSLayoutConstraint.activate([
            startGameBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            startGameBtn.widthAnchor.constraint(equalToConstant: 120),
            startGameBtn.bottomAnchor.constraint(equalTo: settingsBtn.topAnchor, constant: -40),

            settingsBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsBtn.widthAnchor.constraint(equalToConstant: 120),
            settingsBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
        ])
    }

    @objc private func handleStartGameBtnTap() {
        delegate?.startGame()
    }

    @objc private func handleSettingsBtnTap() {
        delegate?.openSettings()
    }
}
