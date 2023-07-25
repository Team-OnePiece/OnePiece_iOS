//
//  FeedContentPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit
import SnapKit
import Then

class FeedContentPage: UIViewController {

    let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
    }
    let explainLabel = UILabel().then {
        $0.text = "태그는 최대 6개까지 작성 가능합니다."
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let tagPlusButton = UIButton(type: .system).then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 32)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.backgroundColor = UIColor(named: "grya-000")
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
    }
    let groupChoiceLabel = UILabel().then {
        $0.text = "어느 그룹에 업로드 하시겠습니까?"
        $0.textColor = UIColor(named: "gray-900")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let groupChoiceButton = UIButton(type: .system).then {
        $0.setTitle("2023", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        finishFeedWirte()
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    func addSubViews() {
        [
            placeTextField,
            explainLabel,
            tagPlusButton,
            
            groupChoiceLabel,
            groupChoiceButton
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(25)
        }
        tagPlusButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(23)
            $0.right.equalToSuperview().inset(313)
            $0.height.equalTo(40)
        }
        groupChoiceLabel.snp.makeConstraints {
            $0.top.equalTo(tagPlusButton.snp.bottom).offset(54)
            $0.left.equalToSuperview().inset(25)
        }
        groupChoiceButton.snp.makeConstraints {
            $0.top.equalTo(groupChoiceLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(165)
            $0.height.equalTo(38)
        }
    }
    func finishFeedWirte() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(finishFeed))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    @objc func finishFeed() {
        self.navigationController?.popViewController(animated: true)
        //여기서 서버통신~
    }
}
