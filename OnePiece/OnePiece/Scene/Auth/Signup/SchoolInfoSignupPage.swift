//
//  SchoolInfoSignupPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class SchoolInfoSignupPage: UIViewController, UITextFieldDelegate {

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
        number.returnKeyType = .done
        grade.keyboardType = .numberPad
        studentclass.keyboardType = .numberPad
        number.keyboardType = .numberPad
        grade.delegate = self
        studentclass.delegate = self
        number.delegate = self
        grade.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        studentclass.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        number.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        nextPageButton.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        number.resignFirstResponder()
        return true
    }
    @objc func clickNextPage() {
        self.navigationController?.pushViewController(NickNameSignupPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let schoolGrade = grade.text,
              let schoolClass = studentclass.text,
              let schoolNumber = number.text
        else {return}
        if schoolGrade.isEmpty == true || schoolClass.isEmpty == true || schoolNumber.isEmpty == true {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha = 0.8
        } else {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha  = 1.0
        }
    }
}
