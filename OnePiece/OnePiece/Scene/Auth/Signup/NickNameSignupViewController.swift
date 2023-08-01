//
//  IdSignupPagee.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import Moya
import SnapKit
import Then

class NickNameSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
    private let nickNameTextField = DefaultTextField(placeholder: "별명(2~9자 이내 한글)")
    private let nickNameCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let signupButton = DefaultButton(title: "회원가입", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let progressImage = UIImageView(image: UIImage(named: "progress4"))
    private let nickNameEnterLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nickNameTextField.returnKeyType = .done
        nickNameTextField.delegate = self
        signupButton.addTarget(self, action: #selector(clickMainPage), for: .touchUpInside)
        nickNameCheckButton.addTarget(self, action: #selector(nickNameCheck), for: .touchUpInside)
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        setupKeyboardObservers()
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
            nickNameTextField,
            nickNameCheckButton,
            nickNameEnterLabel,
            signupButton
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
            $0.width.equalTo(340)
            $0.height.equalTo(35)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        nickNameCheckButton.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(44)
            $0.left.equalTo(nickNameTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        nickNameEnterLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
        signupButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
    private func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
      private func removeKeyboardObservers() {
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.signupButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 15)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.signupButton.transform = .identity
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if isBackSpace == -92 {
                          return true
                      }
                }
        guard nickNameTextField.text!.count < 9 else { return false }
        return true
    }

    func signupFailAlert() {
        let alert = DefaultAlert(title: "회원가입 실패")
        self.present(alert, animated: true)
    }
}

extension NickNameSignupViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameTextField.resignFirstResponder()
        return true
    }
    @objc private func nickNameCheck() {
        guard let nickName = nickNameTextField.text,
              !nickName.isEmpty
        else {
            nickNameEnterLabel.text = "별명을 확인하세요"
            return
        }
        provider.request(.nickNameDuplicate(nickName: nickName)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    let alert = DefaultAlert(title: "사용 가능한 별명입니다.")
                    self.present(alert, animated: true)
                case 409:
                    let alert = DefaultAlert(title: "이미 사용 된 별명입니다.")
                    self.present(alert, animated: true)
                default:
                    self.nickNameEnterLabel.text = "별명을 확인하세요."
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }

    @objc private func clickMainPage() {
        let userInfo = UserInfo.shared
        userInfo.nickName = nickNameTextField.text
        provider.request(.signup(UserInfo.shared)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                            self.navigationController?.pushViewController(MainViewController(), animated: true)
                            let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                            self.navigationItem.backBarButtonItem = signupBackbutton
                            self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                            signupBackbutton.setTitleTextAttributes([
                                .font: UIFont(name: "Orbit-Regular", size: 16)
                            ], for: .normal)
                default:
                    self.signupFailAlert()
                    print(result.statusCode)
                }
            case .failure(let err):
                self.signupFailAlert()
                print("\(err.localizedDescription)")
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let nickName = nickNameTextField.text,
              !nickName.isEmpty
        else {
            signupButton.alpha = 0.8
            nickNameCheckButton.alpha = 0.8
            return
        }
        signupButton.alpha  = 1.0
        nickNameCheckButton.alpha = 1.0
    }
}
