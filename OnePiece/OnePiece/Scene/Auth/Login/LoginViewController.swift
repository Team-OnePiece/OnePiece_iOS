import UIKit
import SnapKit
import Then
import Moya

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let buttonStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.spacing = 11
    }
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
    private let loginButton = DefaultButton(type: .system, title: "로그인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
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
            mainLogoImage,
            mainTitleLabel,
            idTextField,
            passwordTextField,
            loginFailLabel,
            signupStackView,
            buttonStackView
        ].forEach({view.addSubview($0)})
        [signupLabel, signupButton].forEach({signupStackView.addArrangedSubview($0)})
        [loginButton, signupStackView].forEach({buttonStackView.addArrangedSubview($0)})
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
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
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
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 15)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.buttonStackView.transform = .identity
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
        guard let id = self.idTextField.text,
              let password = self.passwordTextField.text,
              !(id.isEmpty || password.isEmpty)
        else {
            self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
            self.moveView(targetView: MainViewController(), title: "")
            //프젝완성되면 없앨 코드
            return
        }
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.login(id: id, password: password)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(AuthResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            Token.accessToken = data.accessToken
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
}
