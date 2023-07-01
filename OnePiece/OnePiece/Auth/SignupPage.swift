//
//  SignupPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/06/30.
//

import UIKit
import SnapKit
import Then

class SignupPage: UIViewController {

    let idTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [
                    .foregroundColor: UIColor(named: "charcoal"),
                    .font: UIFont.systemFont(ofSize: 16)
                ])
        $0.autocapitalizationType = .none
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: -17.0, height: 0.0))
        $0.rightViewMode = .always
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        $0.layer.cornerRadius = 10
    }
    let idCheckButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(UIColor(named: "charcoal"), for: .normal)
        $0.backgroundColor = UIColor(named: "pink")
        $0.layer.cornerRadius = 8
    }
    let passwordTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [
                    .foregroundColor: UIColor(named: "charcoal"),
                    .font: UIFont.systemFont(ofSize: 16)
                ])
        $0.autocapitalizationType = .none
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: -17.0, height: 0.0))
        $0.rightViewMode = .always
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        $0.layer.cornerRadius = 10
    }
    let nextPageButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor(named: "darkGreen")
        $0.layer.cornerRadius = 8
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseColor")
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    func addSubViews() {
        [
            idTextField,
            idCheckButton,
            passwordTextField,
            nextPageButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
            $0.height.equalTo(48)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.equalTo(idTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        nextPageButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(19)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
    }
}

