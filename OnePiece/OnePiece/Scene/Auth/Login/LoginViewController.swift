import UIKit
import SnapKit
import Then
import Moya

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 5
    }
    let mainLogoImage = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    let mainTitleLabel = UILabel().then {
        $0.text = "One Piece"
        $0.font = UIFont(name: "Orbit-Regular", size: 24)
        $0.textColor = UIColor(named: "gray-700")
    }
    let idTextField = DefaultTextField(placeholder: "아이디")
    let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    var eyeButton = UIButton(type: .custom)
    var loginButton = DefaultButton(title: "로그인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    let signupLabel = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
    }
    let signupButton = UIButton(type: .system).then {
        $0.backgroundColor = .clear
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor.red, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 14)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        idTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(moveSignupView), for: .touchUpInside)
        showPasswordButton()
        passwordTextField.returnKeyType = .done
        idTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
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
            mainLogoImage,
            mainTitleLabel,
            idTextField,
            passwordTextField,
            loginButton,
            stackView
        ].forEach({view.addSubview($0)})
        [signupLabel, signupButton].forEach({stackView.addArrangedSubview($0)})
    }
    func makeConstraints() {
        //MARK: -디자인 수정되면 다시 레이아웃 잡기
        mainLogoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(169)
            $0.left.equalToSuperview().inset(25)
            $0.width.height.equalTo(35)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(169)
            $0.left.equalTo(mainLogoImage.snp.right).offset(9)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(18)
            $0.left.right.equalToSuperview().inset(25)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(25)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(95)
            $0.left.right.equalToSuperview().inset(25)
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
//암호를 봤다가 다시 감췄을 때 입력하면 암호가 모두 삭제되는 버그 수정하기?버그가 아닐수도...
extension LoginViewController {
    //MARK: 프젝하다가 시간 여유생기면 코드 이해해보기
    private func showPasswordButton() {
        eyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle()
        }))
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        eyeButton.setImage(UIImage(named: "closeEye"), for: .normal)
        self.eyeButton.setImage(UIImage(named: "openEye"), for: .selected)
        self.eyeButton.configuration = buttonConfiguration
        self.passwordTextField.rightView = eyeButton
        self.passwordTextField.rightViewMode = .always
    }
    //MARK: 여기까지
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    @objc func moveSignupView() {
        self.navigationController?.pushViewController(IdSignupViewController(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let id = idTextField.text,
              let password = passwordTextField.text else {return}
        if id.isEmpty == true || password.isEmpty == true {
            loginButton.backgroundColor = UIColor(named: "mainColor-1")
            loginButton.alpha = 0.8
        } else {
            loginButton.backgroundColor = UIColor(named: "mainColor-1")
            loginButton.alpha  = 1.0
        }
    }
    @objc func clickLogin() {
                if (idTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
                    //레이블알림 띄우기
                } else {
                    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
                    guard let idText = self.idTextField.text,
                          let passwordText = self.passwordTextField.text
                    else {return}

                    provider.request(.login(id: idText, password: passwordText)) { res in
                        switch res {
                        case .success(let result):
                            switch result.statusCode {
                            case 200:
                                if let data = try? JSONDecoder().decode(AuthResponse.self, from: result.data) {
                                    DispatchQueue.main.async {
//                                                                        Token.accessToken = data.token
                                        self.navigationController?.pushViewController(MainViewController(), animated: true)
                                        let loginBackbutton = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
                                        self.navigationItem.backBarButtonItem = loginBackbutton
                                        self.navigationItem.backBarButtonItem?.tintColor = .black
                                    }
                                } else {
                                    print("auth json decode fail")
                                    let alert = DefaultAlert(title: "로그인 실패")
                                    print(result.statusCode)
                                    self.present(alert, animated: true)
                                }
                            default:
                                let alert = DefaultAlert(title: "로그인 실패")
                                print(result.statusCode)
                                self.present(alert, animated: true)
                            }
                        case .failure(let err):
                            print("\(err.localizedDescription)")
                            let alert = DefaultAlert(title: "로그인 실패")
                            self.present(alert, animated: true)
                        }
                    }
                }
        self.navigationController?.pushViewController(FeedContentViewController(), animated: true)
        let loginBackbutton = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = loginBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
}
