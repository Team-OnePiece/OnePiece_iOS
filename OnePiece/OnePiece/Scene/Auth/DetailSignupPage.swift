import UIKit
import SnapKit
import Then

class DetailSignupPage: UIViewController {

    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 80
        $0.clipsToBounds = true
    }// 이미지 크기 조정하는 법 공부하기
    let addImageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
    }
    let imageAdd = UIButton(type: .system).then {
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.backgroundColor = .none
    }
    let studentGrade = DefaultTextField(placeholder: "학년")
    let studentClass = DefaultTextField(placeholder: "반")
    let studentNumber = DefaultTextField(placeholder: "번호")
    let nickName = DefaultTextField(placeholder: "별명")
    let nickNameCheck = DefaultButton(title: "중복확인", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    let signup = DefaultButton(title: "회원가입", backgroundColor: UIColor(named: "mainColor-1")!, titleColor: UIColor(named: "gray-000")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
        signup.addTarget(self, action: #selector(clickSignupFinish), for: .touchUpInside)
        nickNameCheck.addTarget(self, action: #selector(clickNameCheck), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            profileImage,
            imageAdd,
            addImageView,
            studentGrade,
            studentClass,
            studentNumber,
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
        addImageView.snp.makeConstraints {
            $0.center.equalTo(profileImage)
        }
        imageAdd.snp.makeConstraints {//디자인 완성되면 레이아웃 수정하기
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        studentGrade.snp.makeConstraints {
            $0.top.equalTo(imageAdd.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(25)
        }
        studentClass.snp.makeConstraints {
            $0.top.equalTo(imageAdd.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(studentGrade.snp.right).offset(5)
            $0.right.equalToSuperview().inset(140)
        }
        studentNumber.snp.makeConstraints {
            $0.top.equalTo(imageAdd.snp.bottom).offset(10)
            $0.left.equalTo(studentClass.snp.right).offset(5)
            $0.right.equalToSuperview().inset(25)
        }
        nickName.snp.makeConstraints {
            $0.top.equalTo(studentGrade.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(105)
        }
        nickNameCheck.snp.makeConstraints {
            $0.top.equalTo(studentGrade.snp.bottom).offset(6)
            $0.left.equalTo(nickName.snp.right).offset(8)
            $0.right.equalToSuperview().inset(25)
        }
        signup.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(25)
        }
    }
    
    @objc func clickNameCheck() {
        let idAlert  = DefaultAlert(title: "사용 가능한 별명입니다.")
        present(idAlert, animated: true, completion: nil)
    }
    
    @objc func clickSignupFinish() {
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
