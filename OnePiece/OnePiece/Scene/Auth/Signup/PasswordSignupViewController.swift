import UIKit
import Moya
import SnapKit
import Then

class PasswordSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    private let passwordCheckTextField = DefaultTextField(placeholder: "비밀번호 확인", isSecure: true)
    private var eyeButton = UIButton(type: .custom)
    private var checkEyeButton = UIButton(type: .custom)
    private let progressImage = UIImageView(image: UIImage(named: "progress2"))
    private let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        passwordCheckTextField.returnKeyType = .done
        nextPageButton.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        passwordCheckTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        showPasswordButton()
        checkShowPasswordButton()
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
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(25)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.left.right.equalToSuperview().inset(25)
        }
    }
    @objc private func clickNextPage() {
        let userInfo = UserInfo.shared
        userInfo.password = passwordTextField.text
        userInfo.passwordValid = passwordCheckTextField.text
        self.navigationController?.pushViewController(SchoolInfoSignupViewController(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
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
    
    private func checkShowPasswordButton() {
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
              let passwordCheck = passwordCheckTextField.text
        else {return}
        if password.isEmpty || passwordCheck.isEmpty {
            nextPageButton.alpha = 0.8
        } else {
            nextPageButton.alpha  = 1.0
        }
    }
}
