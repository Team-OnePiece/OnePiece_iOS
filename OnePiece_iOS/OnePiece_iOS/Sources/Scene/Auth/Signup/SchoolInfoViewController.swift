import UIKit
import Moya
import SnapKit
import Then

class SchoolInfoSignupViewController: UIViewController, UITextFieldDelegate {
    
    private let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 5
    }
    private let gradeTextField = DefaultTextField(placeholder: "학년").then {
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let classTextField = DefaultTextField(placeholder: "반").then {
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let numberTextField = DefaultTextField(placeholder: "번호").then {
        $0.returnKeyType = .done
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let nextPageButton = DefaultButton(type: .system, title: "다음", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(clickNextPage), for: .touchUpInside)
    }
    private let progressImage = UIImageView(image: UIImage(named: "progress3"))
    private let schoolInfoEnterLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        gradeTextField.delegate = self
        classTextField.delegate = self
        numberTextField.delegate = self
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
            stackView,
            schoolInfoEnterLabel,
            nextPageButton
        ].forEach({view.addSubview($0)})
        [gradeTextField, classTextField, numberTextField].forEach({stackView.addArrangedSubview($0)})
    }
    private func makeConstraints() {
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
            $0.width.equalTo(340)
            $0.height.equalTo(35)
        }
        gradeTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        classTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        numberTextField.snp.makeConstraints  {
            $0.height.equalTo(48)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom).offset(43)
            $0.left.right.equalToSuperview().inset(25)
        }
        schoolInfoEnterLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numberTextField.resignFirstResponder()
        return true
    }
}
extension SchoolInfoSignupViewController {
    @objc private func clickNextPage() {
        let userInfo = UserInfo.shared
        guard let schoolGrade = gradeTextField.text,
              let schoolClass = classTextField.text,
              let schoolNumber = numberTextField.text,
              !(schoolGrade.isEmpty || schoolClass.isEmpty || schoolNumber.isEmpty)
        else {
            schoolInfoEnterLabel.text = "다시 확인하세요."
            return
        }
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.studentInfoDuplicate(grade: Int(schoolGrade)!, classNumber: Int(schoolClass)!, number: Int(schoolNumber)!)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    userInfo.grade = Int(schoolGrade)
                    userInfo.classNumber = Int(schoolClass)
                    userInfo.number = Int(schoolNumber)
                    self.schoolInfoEnterLabel.text = ""
                    self.navigationController?.pushViewController(NickNameSignupViewController(), animated: true)
                    let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                    self.navigationItem.backBarButtonItem = signupBackbutton
                    self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                    signupBackbutton.setTitleTextAttributes([
                        .font: UIFont(name: "Orbit-Regular", size: 16)!
                    ], for: .normal)
                case 409:
                    self.schoolInfoEnterLabel.text = "다시 확인하세요."
                default:
                    self.schoolInfoEnterLabel.text = "다시 확인하세요."
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let schoolGrade = gradeTextField.text,
              let schoolClass = classTextField.text,
              let schoolNumber = numberTextField.text,
              !(schoolGrade.isEmpty || schoolClass.isEmpty || schoolNumber.isEmpty)
        else {
            nextPageButton.isEnabled = false
            nextPageButton.alpha = 0.8
            return
        }
        nextPageButton.isEnabled = true
        nextPageButton.alpha = 1.0
    }
}
