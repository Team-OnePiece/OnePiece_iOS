//
//  DefaultButton.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/07.
//

import UIKit
import SnapKit
import Then

class DefaultButton: UIButton {
    
    init(
        title: String,
        backgroundColor : UIColor,
        titleColor: UIColor
    ) {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 8
        self.alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
