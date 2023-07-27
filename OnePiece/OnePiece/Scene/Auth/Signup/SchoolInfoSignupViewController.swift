//
//  SchoolInfoSignupPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import Moya
import SnapKit
import Then

class SchoolInfoSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 5
    }
    private let progress = UIImageView().then {
        $0.image = UIImage(named: "progress3")
    }
    private let gradeTextField = DefaultTextField(placeholder: "학년")
    private let classTextField = DefaultTextField(placeholder: "반")
    private let numberTextField = DefaultTextField(placeholder: "번호")
    private let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        numberTextField.returnKeyType = .done
        gradeTextField.keyboardType = .numberPad
        classTextField.keyboardType = .numberPad
        numberTextField.keyboardType = .numberPad
        gradeTextField.delegate = self
        classTextField.delegate = self
        numberTextField.delegate = self
        gradeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        classTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        numberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        nextPageButton.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    private func addSubViews() {
        [
            progress,
            stackView,
            nextPageButton
        ].forEach({view.addSubview($0)})
        [gradeTextField, classTextField, numberTextField].forEach({stackView.addArrangedSubview($0)})
    }
    private func makeConstraints() {
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
        numberTextField.resignFirstResponder()
        return true
    }
}
extension SchoolInfoSignupViewController {
    @objc private func clickNextPage() {
        let userInfo = UserInfo.shared
        userInfo.grade = Int(gradeTextField.text!)
        userInfo.classNumber = Int(classTextField.text!)
        userInfo.number = Int(numberTextField.text!)
        self.navigationController?.pushViewController(NickNameSignupViewController(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let schoolGrade = gradeTextField.text,
              let schoolClass = classTextField.text,
              let schoolNumber = numberTextField.text
        else {return}
        if schoolGrade.isEmpty || schoolClass.isEmpty || schoolNumber.isEmpty {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha = 0.8
        } else {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha  = 1.0
        }
    }
}

