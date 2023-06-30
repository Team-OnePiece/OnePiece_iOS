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
        $0.placeholder = "아이디"
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
    let passwordTextField = UITextField().then {
        $0.placeholder = "아이디"
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
            passwordTextField,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
            $0.height.equalTo(48)
        }
    }
}
