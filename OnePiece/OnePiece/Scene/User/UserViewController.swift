//
//  MyPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class UserViewController: UIViewController {

    private let profileBackground = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 50
        $0.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profile")
    }
    private let messageLabel = UILabel().then {
        $0.text = "\t\t\t00님,\n\t\t\t오늘은\n어떤 하루를 보냈나요?"
        $0.numberOfLines = 3
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "gray-800")
    }
    private let modifyButton = DefaultButton(title: "수정하기", backgroundColor: .white, titleColor: UIColor(named: "gray-700")!).then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        modifyButton.addTarget(self, action: #selector(clickModifyPage), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        layout()
    }
    private func layout() {
        [
            profileBackground,
            messageLabel,
            modifyButton
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
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
        }
        modifyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(61)
            $0.left.right.equalToSuperview().inset(25)
        }
    }

    @objc private func clickModifyPage() {
        self.navigationController?.pushViewController(UserModifyViewController(), animated: true)
        let myPageBackbutton = UIBarButtonItem(title: "프로필 수정", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = myPageBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        myPageBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
}
