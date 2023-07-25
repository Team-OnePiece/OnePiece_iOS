//
//  IdSignupPagee.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/11.
//

import UIKit
import SnapKit
import Then
import Moya

class NickNameSignupViewController: UIViewController, UITextFieldDelegate {

    private let nickNameTextField = DefaultTextField(placeholder: "별명")
    private let nickNameCheckButton = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let nextPageButton = DefaultButton(title: "회원가입", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let progress = UIImageView().then {
        $0.image = UIImage(named: "progress4")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nickNameTextField.returnKeyType = .done
        nickNameTextField.delegate = self
        nextPageButton.addTarget(self, action: #selector(clickMainPage), for: .touchUpInside)
        nickNameCheckButton.addTarget(self, action: #selector(nickNameCheck), for: .touchUpInside)
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    private func addSubViews() {
        [
            progress,
            nickNameTextField,
            nickNameCheckButton,
            nextPageButton,
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().inset(131)
            $0.left.right.equalToSuperview().inset(25)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        nickNameCheckButton.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(44)
            $0.left.equalTo(nickNameTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

extension NickNameSignupViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameTextField.resignFirstResponder()
        return true
    }
    @objc private func nickNameCheck() {
        if nickNameTextField.text?.isEmpty == true {
            let enterNickName = DefaultAlert(title: "별명을 입력해주세요.")
            self.present(enterNickName, animated: true)
        } else {
            let nickNameAlert  = DefaultAlert(title: "사용 가능한 별명입니다.")
            self.present(nickNameAlert, animated: true)
        }
    }
    
    @objc private func clickMainPage() {
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        let userInfo = UserInfo.shared
        userInfo.nickName = nickNameTextField.text
        provider.request(.signup(UserInfo.shared)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(AuthResponse.self, from: result.data) {
                        DispatchQueue.main.async {
//                                                                        Token.accessToken = data.token
                            self.navigationController?.pushViewController(MainViewController(), animated: true)
                            let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                            self.navigationItem.backBarButtonItem = signupBackbutton
                            self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                            signupBackbutton.setTitleTextAttributes([
                                .font: UIFont(name: "Orbit-Regular", size: 16)
                            ], for: .normal)
                        }
                    } else {
                        print("auth json decode fail")
                        let alert = DefaultAlert(title: "회원가입 실패")
                        print(result.statusCode)
                        self.present(alert, animated: true)
                    }
                default:
                    let alert = DefaultAlert(title: "회원가입 실패")
                    print(result.statusCode)
                    self.present(alert, animated: true)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
                let alert = DefaultAlert(title: "회원가입 실패")
                self.present(alert, animated: true)
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let nickName = nickNameTextField.text
        else {return}
        if nickName.isEmpty == true {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha = 0.8
            nickNameCheckButton.backgroundColor = UIColor(named: "mainColor-1")
            nickNameCheckButton.alpha = 0.8
        } else {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha  = 1.0
            nickNameCheckButton.backgroundColor = UIColor(named: "mainColor-1")
            nickNameCheckButton.alpha = 1.0
        }
    }
}
