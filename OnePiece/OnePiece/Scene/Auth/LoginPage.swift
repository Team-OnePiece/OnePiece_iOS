import UIKit
import SnapKit
import Then
import Moya

class LoginPage: UIViewController {
    
    let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    let mainLogo = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    let mainTitle = UILabel().then {
        $0.text = "One Piece"
        $0.font = UIFont(name: "Orbit-Regular", size: 24)
        $0.textColor = UIColor(named: "gray-700")
    }
    let idTextField = DefaultTextField(placeholder: "아이디")
    let passwordTextField = DefaultTextField(placeholder: "비밀번호", isSecure: true)
    var eyeButton = UIButton(type: .custom)
    let loginButton = DefaultButton(title: "로그인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
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
        view.backgroundColor = UIColor(named: "mainColor-3")
        loginButton.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(moveSignupView), for: .touchUpInside)
        showPasswordButton()
        //        setupTextFieldHandler()
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            mainLogo,
            mainTitle,
            idTextField,
            passwordTextField,
            loginButton,
            stackView
        ].forEach({view.addSubview($0)})
        [signupLabel, signupButton].forEach({stackView.addArrangedSubview($0)})
    }
    func makeConstraints() {
        //MARK: -디자인 수정되면 다시 레이아웃 잡기
        mainLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(169)
            $0.left.equalToSuperview().inset(25)
            $0.width.height.equalTo(35)
        }
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(169)
            $0.left.equalTo(mainLogo.snp.right).offset(9)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(18)
            $0.right.left.equalToSuperview().inset(25)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.right.left.equalToSuperview().inset(25)
        }
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(96)
            $0.left.right.equalToSuperview().inset(25)
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(11)
            $0.centerX.equalToSuperview()
        }
    }
    //비밀번호가 마지막에 입력되면 버튼색이 안바뀌는 오류
    //    private func setupTextFieldHandler() {
    //           idTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    //       }
    //
    //       @objc private func textFieldDidChange(_ textField: UITextField) {
    //           let textIsEmpty = idTextField.text?.isEmpty ?? true
    //           loginButton.isEnabled = !textIsEmpty
    //           loginButton.backgroundColor = textIsEmpty ? UIColor.blue.cgColor.alpha = 0.1 UIColor(named: "mainColor-1")!
    //       }
    
}
//암호를 봤다가 다시 감췄을 때 입력하면 암호가 모두 삭제되는 버그 수정하기
extension LoginPage {
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
    //MARK: -디자인 바뀌면 네비게이션 바 커스텀하기
    @objc func clickLogin() {
        if (idTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
            //
                        } else {
        
                self.navigationController?.pushViewController(MainPage(), animated: true)
                let loginBackbutton = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = loginBackbutton
                self.navigationItem.backBarButtonItem?.tintColor = .black
            }
                         }
                         
                         @objc func moveSignupView() {
                self.navigationController?.pushViewController(SignupPage(), animated: true)
                let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = signupBackbutton
                self.navigationItem.backBarButtonItem?.tintColor = .black
            }
                         }
                         
