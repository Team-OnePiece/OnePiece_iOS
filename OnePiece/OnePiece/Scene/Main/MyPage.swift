//
//  MyPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class MyPage: UIViewController {

    let profile = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    var userNdame = "user"
    let messageLabel = UILabel().then {
        $0.text = "\t\t\t00님,\n\t\t\t오늘은\n어떤 하루를 보냈나요?"
        $0.numberOfLines = 3
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "gray-800")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
    }
    override func viewDidLayoutSubviews() {
        layout()
    }
    func layout() {
        [
            profile,
            messageLabel
        ].forEach({view.addSubview($0)})
        
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
        }
        func navigationBar() {
            let signupBackbutton = UIBarButtonItem(title: "마이페이지", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = signupBackbutton
            self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
            
            let doneButton = UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = doneButton
            
        }
    }
}
