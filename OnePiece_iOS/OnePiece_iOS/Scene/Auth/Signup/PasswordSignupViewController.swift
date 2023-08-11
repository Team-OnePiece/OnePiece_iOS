import UIKit
import Moya
import SnapKit
import Then

class PasswordSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let passwordTextField = DefaultTextField(placeholder: "비밀번호(16자이내 영문,숫자,특수문자)", isSecure: true).then {
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let passwordCheckTextField = DefaultTextField(placeholder: "비밀번호 확인", isSecure: true).then {
        $0.returnKeyType = .done
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)

    }
    private var eyeButton = UIButton(type: .custom)
    private var checkEyeButton = UIButton(type: .custom)
    private let progressImage = UIImageView(image: UIImage(named: "progress2"))
    private let nextPageButton = DefaultButton(type: .system, title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
    }
    private let passwordEnterLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        showPasswordButton()
        showPasswordCheckButton()
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
            passwordTextField,
            passwordCheckTextField,
            progressImage,
            passwordEnterLabel,
            nextPageButton
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
            $0.width.equalTo(340)
            $0.height.equalTo(35)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(48)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(25)
        }
        passwordEnterLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
        nextPageButton.snp.makeConstraints {
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
                self.nextPageButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 15)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.nextPageButton.transform = .identity
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if isBackSpace == -92 {
                          return true
                      }
                }
        guard passwordTextField.text!.count < 16 else { return false }
        return true
    }
}

extension PasswordSignupViewController {
    private func showPasswordButton() {
        eyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle()
        }))
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        eyeButton.setImage (UIImage (named: "closeEye"), for: .normal)
        self.eyeButton.setImage(UIImage (named: "openEye"), for: .selected)
        self.eyeButton.configuration = buttonConfiguration
        self.passwordTextField.rightView = eyeButton
        self.passwordTextField.rightViewMode = .always
    }
    
    private func showPasswordCheckButton() {
        checkEyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordCheckTextField.isSecureTextEntry.toggle()
            self.checkEyeButton.isSelected.toggle ()
        }))
        var buttonConfiguration2 = UIButton.Configuration.plain()
        buttonConfiguration2.imagePadding = 10
        buttonConfiguration2.baseBackgroundColor = .clear
        checkEyeButton.setImage (UIImage (named: "closeEye"), for: .normal)
        self.checkEyeButton.setImage(UIImage (named: "openEye"), for: .selected)
        self.checkEyeButton.configuration = buttonConfiguration2
        self.passwordCheckTextField.rightView = checkEyeButton
        self.passwordCheckTextField.rightViewMode = .always
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordCheckTextField.resignFirstResponder()
        }
        return true
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let password = passwordTextField.text,
              let passwordCheck = passwordCheckTextField.text,
              !(password.isEmpty || passwordCheck.isEmpty) && password == passwordCheck
        else {
            nextPageButton.isEnabled = false
            nextPageButton.alpha = 0.8
            return
        }
        nextPageButton.isEnabled = true
        nextPageButton.alpha  = 1.0
    }
    @objc private func clickNextPage() {
        let userInfo = UserInfo.shared
        guard let password = passwordTextField.text,
              let passwordCheck = passwordCheckTextField.text,

              !(password.isEmpty || passwordCheck.isEmpty)
        else {return}
        userInfo.password = password
        userInfo.passwordValid = passwordCheck
        passwordEnterLabel.text = ""
        self.navigationController?.pushViewController(SchoolInfoSignupViewController(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
}
