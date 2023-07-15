//
//  IdSignupPagee.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class NickNameSignupPage: UIViewController, UITextFieldDelegate {

    let nickNameTextField = DefaultTextField(placeholder: "별명")
    let nickNameCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    let nextPageButton = DefaultButton(title: "회원가입", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    let progress = UIImageView().then {
        $0.image = UIImage(named: "progress4")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nickNameTextField.returnKeyType = .done
        nickNameTextField.delegate = self
        nextPageButton.addTarget(self, action: #selector(clickMainPage), for: .touchUpInside)
        nickNameCheckButton.addTarget(self, action: #selector(nickNameCheck), for: .touchUpInside)
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
            nickNameTextField,
            nickNameCheckButton,
            nextPageButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().inset(131)
            $0.left.right.equalToSuperview().inset(25)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        nickNameCheckButton.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalTo(nickNameTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(479)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

extension NickNameSignupPage {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameTextField.resignFirstResponder()
        return true
    }
    @objc func nickNameCheck() {
        let idAlert  = DefaultAlert(title: "사용 가능한 별명입니다.")
        self.present(idAlert, animated: true)
    }
    
    @objc func clickMainPage() {
        self.navigationController?.pushViewController(MainPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
}
