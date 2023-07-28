//
//  IdSignupPagee.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import Moya
import SnapKit
import Then

class IdSignupViewController: UIViewController, UITextFieldDelegate {

    private let idTextField = DefaultTextField(placeholder: "아이디")
    private let idCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let progressImage = UIImageView(image: UIImage(named: "progress1"))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        idTextField.delegate = self
        idTextField.returnKeyType = .done
        nextPageButton.addTarget(self, action: #selector(clickNextePage), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(idCheck), for: .touchUpInside)
        idTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    private func addSubViews() {
        [
            progressImage,
            idTextField,
            idCheckButton,
            nextPageButton
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
            $0.width.equalTo(340)
            $0.height.equalTo(35)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(44)
            $0.left.equalTo(idTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(46)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

extension IdSignupViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idTextField.resignFirstResponder()
        return true
    }
    @objc private func idCheck() {
        //서버 통신 완료 후 수정
        if idTextField.text?.isEmpty == true {
            let enterId = DefaultAlert(title: "아이디를 입력해주세요.")
            self.present(enterId, animated: true)
        } else {
            let idAlert  = DefaultAlert(title: "사용 가능한 아이디입니다.")
            self.present(idAlert, animated: true)
        }
    }
    @objc private func clickNextePage() {
        let userInfo = UserInfo.shared
        userInfo.accountId = idTextField.text
        self.navigationController?.pushViewController(PasswordSignupViewController(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let id = idTextField.text else {return}
        if id.isEmpty{
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha = 0.8
            idCheckButton.backgroundColor = UIColor(named: "mainColor-1")
            idCheckButton.alpha = 0.8
        } else {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha  = 1.0
            idCheckButton.backgroundColor = UIColor(named: "mainColor-1")
            idCheckButton.alpha = 1.0
        }
    }
}