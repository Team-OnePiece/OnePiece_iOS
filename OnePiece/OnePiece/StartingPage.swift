import UIKit
import SnapKit
import Then

class StartingPage: UIViewController {

    let slogan = UILabel().then {
        $0.text = "단 한장의 사진으로"
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "charcoal")
    }
    let mainTitle = UILabel().then {
        $0.text = "One Piece"
        $0.font = UIFont(name: "Orbit-Regular", size: 36)
        $0.textColor = .black
    }
    let mainIcon = UIImageView().then {
        $0.image = UIImage(named: "mainIcon")
    }
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    let signupButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor(named: "darkGreen")
        $0.layer.cornerRadius = 8
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseColor")
        loginButton.addTarget(self, action: #selector(moveloginView), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(moveSignupView), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            slogan,
            mainTitle,
            mainIcon,
            loginButton,
            signupButton,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
    //MARK: -디자인 수정되면 다시 레이아웃 잡기
        slogan.snp.makeConstraints {
            $0.top.equalToSuperview().inset(198)
            $0.centerX.equalToSuperview()
        }
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(slogan.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        mainIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(326)
            $0.bottom.equalToSuperview().inset(363.7)
            $0.left.right.equalToSuperview().inset(115)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(166)
            $0.left.right.equalToSuperview().inset(51)
            $0.height.equalTo(48)
        }
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(51)
            $0.height.equalTo(48)
        }
    }
    
    @objc func moveloginView() {
        self.navigationController?.pushViewController(LoginPage(), animated: true)
        let loginBackbutton = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = loginBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    @objc func moveSignupView() {
        self.navigationController?.pushViewController(SignupPage(), animated: true)
        let signupBackbutton = UIBarButtonItem(title: "회원가입", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Orbit-Regular", size: 16)], for: .normal)
        self.navigationItem.backBarButtonItem = signupBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
}

