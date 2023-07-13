//
//  MyPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class UserModifyPage: UIViewController {

    let profileBackground = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 50
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
}
