//
//  SettingsView.swift
//  Tetris
//
//  Created by Dmitry Pushin on 05.01.2022.
//  Copyright © 2022 Dmitry Pushin. All rights reserved.
//

import UIKit

private struct Layout {
    static let backButtonLeading: CGFloat = 25
    static let backButtonSize: CGFloat = 30
    static let tableViewTopMargin: CGFloat = 10
}

protocol SettingsViewOutput: AnyObject {
    func tapOnBackBtn()
}

private enum TableElements: CaseIterable {
    case fieldSize
    case onlyStandartFigures
    case figuresMaker
    case availableFigures
}

class SettingsView: UIView {
    weak var delegate: SettingsViewOutput?

    private var elements: [TableElements] = TableElements.allCases

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

    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubView()
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureSubView() {
        addSubview(backBtn)
        addSubview(tableView)
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: Layout.backButtonSize),
            backBtn.heightAnchor.constraint(equalToConstant: Layout.backButtonSize),
            backBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Layout.backButtonLeading),
            backBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.backButtonLeading)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func tapBack(_ sender: Any?) {
        delegate?.tapOnBackBtn()
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

final class PickerTableViewCell: UITableViewCell {
    enum PickerType: Int {
        case row = 0
        case column
    }

    var rowPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerType.row.rawValue
        return picker
    }()

    var columnPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerType.column.rawValue
        return picker
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        rowPicker.delegate = self
        rowPicker.dataSource = self
        columnPicker.delegate = self
        columnPicker.dataSource = self


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}
