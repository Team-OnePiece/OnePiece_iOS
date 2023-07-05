//
//  LoginPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/06/30.
//

import UIKit
import SnapKit
import Then

class LoginPage: UIViewController {

    let idTextField = DefaultTextField(placeholder: "아이디")
    let passwordTextField = DefaultTextField(placeholder: "비밀번호")
    let nextPageButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.backgroundColor = UIColor(named: "darkGreen")
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseColor")
        nextPageButton.addTarget(self, action: #selector(nextSignupPage), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    func addSubViews() {
        [
            idTextField,
            passwordTextField,
            nextPageButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.right.equalToSuperview().inset(25)
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
    
    @objc func nextSignupPage() {
        navigationController?.pushViewController(MainPage(), animated: true)
            let signupBackbutton = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = signupBackbutton
            self.navigationItem.backBarButtonItem?.tintColor = .black
        }
}
