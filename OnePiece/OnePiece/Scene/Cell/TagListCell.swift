//
//  TagListCell.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/25.
//

import UIKit
import SnapKit
import Then

class TagListCell: UICollectionViewCell {
    let tagTextField = UITextField().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.font = UIFont(name: "Orbit-Regular", size: 18)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        $0.leftView = spacerView
        $0.leftViewMode = .always
        $0.rightView = spacerView
        $0.rightViewMode = .always
    }
    let tagDeleteButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "tagDeleteIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagTextField)
        contentView.addSubview(tagDeleteButton)
        tagTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.left.right.equalToSuperview().inset(3)
            $0.height.equalTo(40)
        }
        tagDeleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(10)
        }
        tagTextField.delegate = self
    }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
extension TagListCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if isBackSpace == -92 {
                          return true
                      }
                }
        guard tagTextField.text!.count < 10 else { return false } // 10 글자로 제한
        return true
    }
}
