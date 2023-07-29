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
    private let gradeTextField = DefaultTextField(placeholder: "학년")
    private let classTextField = DefaultTextField(placeholder: "반")
    private let numberTextField = DefaultTextField(placeholder: "번호")
    private let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let progressImage = UIImageView(image: UIImage(named: "progress3"))
    private let schoolInfoEnterLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
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
            progressImage,
            stackView,
            schoolInfoEnterLabel,
            nextPageButton
        ].forEach({view.addSubview($0)})
        [gradeTextField, classTextField, numberTextField].forEach({stackView.addArrangedSubview($0)})
    }
    private func makeConstraints() {
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
            $0.width.equalTo(340)
            $0.height.equalTo(35)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(43)
            $0.left.right.equalToSuperview().inset(25)
        }
        schoolInfoEnterLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
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
        guard let schoolGrade = gradeTextField.text,
              let schoolClass = classTextField.text,
              let schoolNumber = numberTextField.text,
              !(schoolGrade.isEmpty || schoolClass.isEmpty || schoolNumber.isEmpty)
        else {
            schoolInfoEnterLabel.text = "다시 확인하세요."
            return
        }
        schoolInfoEnterLabel.text = ""
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
              let schoolNumber = numberTextField.text,
              !(schoolGrade.isEmpty || schoolClass.isEmpty || schoolNumber.isEmpty)
        else {
            nextPageButton.alpha = 0.8
            return
        }
        nextPageButton.alpha = 1.0
    }
}

