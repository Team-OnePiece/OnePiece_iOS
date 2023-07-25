//
//  alert.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/19.
//

import UIKit
import SnapKit
import Then

class ContentAlert: UIViewController {
    let modifyButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        modifyButton.addTarget(self, action: #selector(clickModify), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        layout()
    }
    func layout() {
        [background].forEach({view.addSubview($0)})
        [modifyButton, deleteButton, line].forEach({background.addSubview($0)})
        
        background.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(160)
        }
        modifyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.left.right.equalToSuperview().inset(163)
        }
        line.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(0.7)
        }
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(31)
            $0.left.right.equalToSuperview().inset(163)
        }
    }
    @objc func clickModify() {
        self.dismiss(animated: true)
        self.navigationController?.present(FeedModifyViewController(), animated: true)
    }
    @objc func clickDelete() {
        self.dismiss(animated: true)
    }
}
