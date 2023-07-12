//
//  SchoolInfoSignupPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class SchoolInfoSignupPage: UIViewController {

    let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 5
    }
    let progress = UIImageView().then {
        $0.image = UIImage(named: "progress3")
    }
    let grade = DefaultTextField(placeholder: "학년")
    let studentclass = DefaultTextField(placeholder: "반")
    let number = DefaultTextField(placeholder: "번호")
    let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nextPageButton.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    func addSubViews() {
        [
            progress,
            stackView,
            nextPageButton
        ].forEach({view.addSubview($0)})
        [grade, studentclass, number].forEach({stackView.addArrangedSubview($0)})
    }
    func makeConstraints() {
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().inset(131)
            $0.left.right.equalToSuperview().inset(25)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(43)
            $0.left.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
    
    @objc func clickNextPage() {
        self.navigationController?.pushViewController(NickNameSignupPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
}
