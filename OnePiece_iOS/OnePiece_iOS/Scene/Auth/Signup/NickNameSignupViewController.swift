import UIKit
import Moya
import SnapKit
import Then

class NickNameSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
    private let nickNameTextField = DefaultTextField(placeholder: "별명(2~9자 이내 한글)").then {
        $0.returnKeyType = .done
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let signupButton = DefaultButton(type: .system, title: "회원가입", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(clickMoveMainPage), for: .touchUpInside)
    }
    private let progressImage = UIImageView(image: UIImage(named: "progress4"))
    private let nickNameEnterLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nickNameTextField.delegate = self
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
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameTextField.resignFirstResponder()
        return true
    }
}

extension NickNameSignupViewController {
    
    @objc private func clickMoveMainPage() {
        let userInfo = UserInfo.shared
        guard let nickName = nickNameTextField.text,
              !nickName.isEmpty
        else {return}
        provider.request(.nickNameDuplicate(nickName: nickName)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    print("중복확인 성공")
                    userInfo.nickName = nickName
                    self.signup()
                case 409:
                    self.nickNameEnterLabel.text = "이미 사용 된 별명입니다."
                default:
                    self.nickNameEnterLabel.text = "별명을 확인하세요."
                    print(result.statusCode)
                }
            case .failure(let err):
                self.nickNameEnterLabel.text = "회원가입에 실패하였습니다."
                print("\(err.localizedDescription)")
            }
        }
    }
   private func signup() {
        provider.request(.signup(UserInfo.shared)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    print("회원가입 성공")
                    let alert = DefaultAlert(title: "회원가입에 성공하였습니다.")
                    self.present(alert, animated: true)
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                    let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                    self.navigationItem.backBarButtonItem = signupBackbutton
                    self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                    signupBackbutton.setTitleTextAttributes([
                        .font: UIFont(name: "Orbit-Regular", size: 16)!
                    ], for: .normal)
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let nickName = nickNameTextField.text,
              !nickName.isEmpty
        else {
            signupButton.isEnabled = false
            signupButton.alpha = 0.8
            return
        }
        signupButton.isEnabled = true
        signupButton.alpha  = 1.0
    }
}
