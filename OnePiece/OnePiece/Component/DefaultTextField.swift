//
//  DefaultTextField.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/05.
//

import UIKit
import SnapKit
import Then

class DefaultTextField: UITextField {

    private var placeholderText: String = ""

    init(
        placeholder: String,
        isSecure: Bool = false
    ) {
        super.init(frame: .zero)
        self.placeholderText = placeholder
        self.font = UIFont.systemFont(ofSize: 16)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.isSecureTextEntry = isSecure
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        self.leftView = spacerView
        self.rightView = spacerView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
        fieldSetting()
    }

    private func makeConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    private func fieldSetting() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "mainColor-4"),
                NSAttributedString.Key.font: UIFont(name: "Orbit-Regular", size: 16) as Any
            ]
        )
    }
}

