import UIKit
import SnapKit
import Then
import Moya

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let signupStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 5
    }
    private let mainLogoImage = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    private let mainTitleLabel = UILabel().then {
        $0.text = "One Piece"
        $0.font = UIFont(name: "Orbit-Regular", size: 24)
        $0.textColor = UIColor(named: "gray-700")
    }
    private let idTextField = DefaultTextField(placeholder: "아이디")
    private let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    private var eyeButton = UIButton(type: .custom)
    private let loginButton = DefaultButton(title: "로그인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    private let loginFailLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let signupLabel = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
    }
    private let signupButton = UIButton(type: .system).then {
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
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    private func addSubViews() {
        [
            mainLogoImage,
            mainTitleLabel,
            idTextField,
            passwordTextField,
            loginFailLabel,
            loginButton,
            signupStackView
        ].forEach({view.addSubview($0)})
        [signupLabel, signupButton].forEach({signupStackView.addArrangedSubview($0)})
    }
    private func makeConstraints() {
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
        loginFailLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(95)
            $0.left.right.equalToSuperview().inset(25)
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        signupStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
extension LoginViewController {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    private func moveView(targetView: UIViewController, title: String) {
        self.navigationController?.pushViewController(targetView, animated: true)
        let toMoveView = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = toMoveView
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        toMoveView.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    @objc private func moveSignupView() {
        moveView(targetView: IdSignupViewController(), title: "회원가입")
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let id = idTextField.text,
              let password = passwordTextField.text,
              !(id.isEmpty || password.isEmpty)
        else {
            loginButton.alpha = 0.8
            return
        }
        loginButton.alpha = 1.0
    }
    @objc private func clickLogin() {
        if (idTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
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
                                //Token.accessToken = data.token
                                self.moveView(targetView: MainViewController(), title: "")
                            }
                        } else {
                            self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
                            print("auth json decode fail")
                            print(result.statusCode)
                        }
                    default:
                        self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
                        print(result.statusCode)
                    }
                case .failure(let err):
                    self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
                    print("\(err.localizedDescription)")
                }
            }
        }
        self.moveView(targetView: MainViewController(), title: "")
        //프젝완성되면 없앨 코드
    }
}
