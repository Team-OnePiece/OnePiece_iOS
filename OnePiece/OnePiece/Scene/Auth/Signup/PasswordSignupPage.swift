import UIKit
import Moya
import SnapKit
import Then

class PasswordSignupPage: UIViewController, UITextFieldDelegate {
    
    let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    let passwordCheckTextField = DefaultTextField(placeholder: "비밀번호 확인", isSecure: true)
    var eyeButton = UIButton(type: .custom)
    var checkEyeButton = UIButton(type: .custom)
    let progress = UIImageView().then {
        $0.image = UIImage(named: "progress2")
    }
    let nextPageButton = DefaultButton(title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
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
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    func addSubViews() {
        [
            passwordTextField,
            passwordCheckTextField,
            progress,
            nextPageButton
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().inset(131)
            $0.left.right.equalToSuperview().inset(25)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(48)
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
    @objc func clickNextPage() {
        let userInfo = UserInfo.shared
        userInfo.password = passwordTextField.text
        userInfo.passwordValid = passwordCheckTextField.text
        self.navigationController?.pushViewController(SchoolInfoSignupPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        signupBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
}

extension PasswordSignupPage {
    func showPasswordButton() {
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
    
    func checkShowPasswordButton() {
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let password = passwordTextField.text,
              let passwordCheck = passwordCheckTextField.text
        else {return}
        if password.isEmpty == true || passwordCheck.isEmpty == true {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha = 0.8
        } else {
            nextPageButton.backgroundColor = UIColor(named: "mainColor-1")
            nextPageButton.alpha  = 1.0
        }
    }
}
