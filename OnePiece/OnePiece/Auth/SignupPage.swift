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

    let idTextField = DefaultTextField(placeholder: "아이디")
    let idCheckButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.setTitleColor(UIColor(named: "gray-000"), for: .normal)
        $0.backgroundColor = UIColor(named: "mainColor-1")
        $0.layer.cornerRadius = 8
    }
    let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    let nextPageButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-000"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.backgroundColor = UIColor(named: "mainColor-1")
        $0.layer.cornerRadius = 8
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
        nextPageButton.addTarget(self, action: #selector(nextSignupPage), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(idCheck), for: .touchUpInside)
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
            $0.top.equalTo(passwordTextField.snp.bottom).offset(73)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
    }
    
    @objc func idCheck() {
        let idAlert  = DefaultAlert()
        idAlert.alertMessage(title: "사용 가능한 아이디입니다.")
        present(idAlert, animated: true, completion: nil)
    }
    
    @objc func nextSignupPage() {
        navigationController?.pushViewController(DetailSignupPage(), animated: true)
            let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = signupBackbutton
            self.navigationItem.backBarButtonItem?.tintColor = .black
        }
}

