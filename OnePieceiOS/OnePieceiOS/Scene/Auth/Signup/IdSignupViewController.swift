import UIKit
import Moya
import SnapKit
import Then

class IdSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let idTextField = DefaultTextField(placeholder: "아이디(영문, 숫자 7~20자)")
    private let nextPageButton = DefaultButton(type: .system, title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!).then {
        $0.isEnabled = false
    }
    private let progressImage = UIImageView(image: UIImage(named: "progress1"))
    private let idEnterLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        idTextField.delegate = self
        idTextField.returnKeyType = .done
        nextPageButton.addTarget(self, action: #selector(clickNextePage), for: .touchUpInside)
        idTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
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
            idTextField,
            idEnterLabel,
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
        idTextField.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(44)
            $0.left.right.equalToSuperview().inset(25)
        }
        idEnterLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
        nextPageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(46)
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
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let id = idTextField.text,
              !id.isEmpty
        else {
            nextPageButton.isEnabled = false
            nextPageButton.alpha = 0.8
            return
        }
        nextPageButton.isEnabled = true
        nextPageButton.alpha  = 1.0
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if isBackSpace == -92 {
                          return true
                      }
                }
        guard idTextField.text!.count < 20 else { return false }
        return true
    }
}

extension IdSignupViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idTextField.resignFirstResponder()
        return true
    }
    @objc private func clickNextePage() {
        let userInfo = UserInfo.shared
        guard let id = idTextField.text,
              !id.isEmpty
        else {return}
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.idDuplicate(id: id)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    userInfo.accountId = id
                    self.idEnterLabel.text = ""
                    self.navigationController?.pushViewController(PasswordSignupViewController(), animated: true)
                    let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                    self.navigationItem.backBarButtonItem = signupBackbutton
                    self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                    signupBackbutton.setTitleTextAttributes([
                        .font: UIFont(name: "Orbit-Regular", size: 16)
                    ], for: .normal)
                case 409:
                    let alert = DefaultAlert(title: "이미 사용 된 아이디입니다.")
                    self.present(alert, animated: true)
                default:
                    self.idEnterLabel.text = "아이디를 확인해주세요."
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
