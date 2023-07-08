//
//  SibalViewController.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/09.
//

import UIKit
import SnapKit
import Then

class SignupPage: UIViewController {

    
    let idTextField = DefaultTextField(placeholder: "아이디")
    let idCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    var eyeButton = UIButton(type: .custom)
    let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    let nfextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
        showPasswordButton()
        nfextPageButton.addTarget(self, action: #selector(nextSignupPage), for: .touchUpInside)
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
            nfextPageButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(125)
            $0.left.equalTo(idTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(25)
        }
        nfextPageButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(73)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

extension SignupPage {
    private func showPasswordButton() {
        eyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle ()
        }))
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        eyeButton.setImage (UIImage (named: "closeEye"), for: .normal)
        self.eyeButton.setImage(UIImage (named: "openEye"), for: .selected)
        self.eyeButton.configuration = buttonConfiguration
        self.passwordTextField.rightView = eyeButton
        self.passwordTextField.rightViewMode = .always
    }
    @objc func idCheck() {
        //서버연동하면 중복여부에 따라 알림 메세지가 달라지게하기
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
