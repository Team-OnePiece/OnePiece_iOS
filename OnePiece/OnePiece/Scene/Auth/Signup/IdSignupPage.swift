//
//  IdSignupPagee.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class IdSignupPage: UIViewController, UITextFieldDelegate {

    let idTextField = DefaultTextField(placeholder: "아이디")
    let idCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    var progress = ProgressView(cir1Color: UIColor(named: "mainColor-1")!, cir2Color: UIColor(named: "mainColor-2")!, cir3Color: UIColor(named: "mainColor-2")!, cir4Color: UIColor(named: "mainColor-2")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        idTextField.delegate = self
        idTextField.returnKeyType = .done
        nextPageButton.addTarget(self, action: #selector(clickNextePage), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(idCheck), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    func addSubViews() {
        [
            progress,
            idTextField,
            idCheckButton,
            nextPageButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().offset(131)
            $0.left.right.equalToSuperview().inset(25)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalTo(idTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

extension IdSignupPage {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idTextField.resignFirstResponder()
        return true
    }
    @objc func idCheck() {
        let idAlert  = DefaultAlert(title: "사용 가능한 아이디입니다.")
        self.present(idAlert, animated: true)
    }
    
    @objc func clickNextePage() {
        self.navigationController?.pushViewController(PasswordSignupPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
}
