//
//  MyPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then
import Moya

class UserModifyViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate {
    private let profileBackground = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 50
        $0.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.backgroundColor = .white
    }
    private let profileModifyButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-800"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    private let nickNameModifyTextField = DefaultTextField(placeholder: "")
    private let nickNameCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let nickNameEnterLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        profileModifyButton.addTarget(self, action: #selector(clickProfileModifyButton), for: .touchUpInside)
        nickNameCheckButton.addTarget(self, action: #selector(clickIdCheck), for: .touchUpInside)
        finishModify()
        nickNameModifyTextField.delegate = self
        nickNameModifyTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .allEditingEvents)
    }
    override func viewWillLayoutSubviews() {
        layout()
    }
    private func layout() {
        [
            profileBackground,
            profileModifyButton,
            nickNameModifyTextField,
            nickNameCheckButton,
            nickNameEnterLabel
        ].forEach({view.addSubview($0)})
        profileBackground.addSubview(profileImage)
        
        profileBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        profileImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        profileModifyButton.snp.makeConstraints {
            $0.top.equalTo(profileBackground.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        nickNameModifyTextField.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.bottom).offset(60)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(109)
        }
        nickNameCheckButton.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.bottom).offset(60)
            $0.left.equalTo(nickNameModifyTextField.snp.right).offset(4)
            $0.right.equalToSuperview().inset(25)
        }
        nickNameEnterLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameModifyTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
    }
    private func finishModify() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(clickMoveUserPage))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UserModifyViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.profileBackground.image = img
            self.profileImage.isHidden = true
            self.profileBackground.layer.borderWidth = 0
        }
    }
    @objc private func clickMoveUserPage() {
        guard let nickName = nickNameModifyTextField.text,
              !nickName.isEmpty
        else {
            nickNameEnterLabel.text = "별명을 확인하세요"
            return
        }
        let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.userInfoUpdate(userInfo: nickName)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    let alert = DefaultAlert(title: "별명이 변경되었습니다.")
                    self.present(alert, animated: true)
                    self.navigationController?.popViewController(animated: true)
                default:
                    self.nickNameEnterLabel.text = "별명을 확인하세요"
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
    @objc private func clickProfileModifyButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    @objc private func clickIdCheck() {
        guard let nickNameModify = nickNameModifyTextField.text,
              !nickNameModify.isEmpty
        else {
            nickNameEnterLabel.text = "별명을 입력하세요."
            return
        }
        let alert = DefaultAlert(title: "사용 가능한 별명입니다.")
        self.present(alert, animated: true)
        nickNameEnterLabel.text = ""
        let provider  = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.nickNameDuplicate(nickName: nickNameModify)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    let alert = DefaultAlert(title: "사용 가능한 별명입니다.")
                    self.present(alert, animated: true)
                case 409:
                    let alert = DefaultAlert(title: "이미 사용 된 별명입니다.")
                    self.present(alert, animated: true)
                default:
                    self.nickNameEnterLabel.text = "별명을 확인해주세요."
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let nickNameCheck = nickNameModifyTextField.text,
              !nickNameCheck.isEmpty
        else {
            nickNameCheckButton.alpha = 0.8
            return
        }
        nickNameCheckButton.alpha  = 1.0
    }
}
