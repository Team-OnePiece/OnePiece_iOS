import UIKit
import SnapKit
import Then

class DetailSignupPage: UIViewController {

    let profileImage = UIImageView().then {
        let image = UIImage(named: "profile")
        let resizeImage = image?.resize(to: CGSize(width: 80, height: 80))
        $0.image = resizeImage
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 80
        $0.clipsToBounds = true
    }// 이미지 크기 조정하는 법 공부하기
    let imageAdd = UIButton(type: .system).then {
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.backgroundColor = .none
    }
    let studentId = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "학번", attributes: [
                    .foregroundColor: UIColor(named: "charcoal"),
                    .font: UIFont.systemFont(ofSize: 16)
                ])
        $0.autocapitalizationType = .none
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: -17.0, height: 0.0))
        $0.rightViewMode = .always
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        $0.layer.cornerRadius = 10
    }
    let nickName = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "별명", attributes: [
                    .foregroundColor: UIColor(named: "charcoal"),
                    .font: UIFont.systemFont(ofSize: 16)
                ])
        $0.autocapitalizationType = .none
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: -17.0, height: 0.0))
        $0.rightViewMode = .always
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
        $0.layer.cornerRadius = 10
    }
    let nickNameCheck = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(UIColor(named: "charcoal"), for: .normal)
        $0.backgroundColor = UIColor(named: "pink")
        $0.layer.cornerRadius = 8
    }
    let signup = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.backgroundColor = UIColor(named: "darkGreen")
        $0.layer.cornerRadius = 8
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseColor")
        signup.addTarget(self, action: #selector(signupFinish), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            profileImage,
            imageAdd,
            studentId,
            nickName,
            nickNameCheck,
            signup
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(109)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
        }
        imageAdd.snp.makeConstraints {//디자인 완성되면 레이아웃 수정하기
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        studentId.snp.makeConstraints {
            $0.top.equalTo(imageAdd.snp.bottom).offset(10)//나중에 수정하기
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        nickName.snp.makeConstraints {
            $0.top.equalTo(studentId.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
            $0.height.equalTo(48)
        }
        nickNameCheck.snp.makeConstraints {
            $0.top.equalTo(studentId.snp.bottom).offset(6)
            $0.left.equalTo(nickName.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        signup.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(13)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
    }
    
    @objc func signupFinish() {
        navigationController?.pushViewController(MainPage(), animated: true)
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
// 이미지 크기 resize 코드
