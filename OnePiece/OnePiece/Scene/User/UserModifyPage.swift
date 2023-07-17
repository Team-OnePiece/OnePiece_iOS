//
//  MyPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class UserModifyPage: UIViewController, UINavigationControllerDelegate {

    let profileBackground = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 50
        $0.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    let profile = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.backgroundColor = .white
    }
    let profileModifyButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-800"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let idModifyTextField = DefaultTextField(placeholder: "핫걸")
    let idCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        profileModifyButton.addTarget(self, action: #selector(clickProfileModifyButton), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(clickIdCheck), for: .touchUpInside)
        finishModify()
    }
    override func viewDidLayoutSubviews() {
        layout()
    }
    func layout() {
        [
            profileBackground,
            profileModifyButton,
            idModifyTextField,
            idCheckButton
        ].forEach({view.addSubview($0)})
        profileBackground.addSubview(profile)
        
        profileBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        profile.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        profileModifyButton.snp.makeConstraints {
            $0.top.equalTo(profileBackground.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        idModifyTextField.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.bottom).offset(60)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(109)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.bottom).offset(60)
            $0.left.equalTo(idModifyTextField.snp.right).offset(4)
            $0.right.equalToSuperview().inset(25)
        }
    }
    func finishModify() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(clickMoveUserPage))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)

    }
    @objc func clickMoveUserPage() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func clickProfileModifyButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    @objc func clickIdCheck() {
        let alert = DefaultAlert(title: "사용 가능한 별명입니다.")
        self.present(alert, animated: true)
    }
}

extension UserModifyPage: UIImagePickerControllerDelegate {
//     이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }

    // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.profileBackground.image = img
            self.profile.isHidden = true
            self.profileBackground.layer.borderWidth = 0
        }
    }
}
