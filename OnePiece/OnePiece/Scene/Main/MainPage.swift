//
//  MainPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/02.
//

import UIKit
import SnapKit
import Then

class MainPage: UIViewController {

    let mainLogo = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    let toggleBackground = UIView().then {
        $0.backgroundColor = UIColor(named: "mainColor-2")
        $0.layer.cornerRadius = 10
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
        navigationItem.hidesBackButton = true
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    func addSubViews() {
        [
            mainLogo,
            toggleBackground,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        mainLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        toggleBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(125)
            $0.height.equalTo(35)
        }
    }
}
