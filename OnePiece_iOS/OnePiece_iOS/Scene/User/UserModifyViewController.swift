import UIKit
import SnapKit
import Then
import Moya

class UserModifyViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate {
    private var imageURL: String = ""
    private let profileBackground = UIImageView(image: UIImage(named: "profile")).then {
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    private let profileModifyButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-800"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.addTarget(self, action: #selector(clickProfileModifyButton), for: .touchUpInside)
    }
    private let nickNameModifyTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.isSecureTextEntry = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        $0.leftView = spacerView
        $0.rightView = spacerView
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
    }
    private let nickNameEnterLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nickNameModifyTextField.delegate = self
        finishModify()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadImage()
    }
    override func viewWillLayoutSubviews() {
        layout()
    }
    private func layout() {
        [
            profileBackground,
            profileModifyButton,
            nickNameModifyTextField,
            nickNameEnterLabel
        ].forEach({view.addSubview($0)})
        
        profileBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        profileModifyButton.snp.makeConstraints {
            $0.top.equalTo(profileBackground.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        nickNameModifyTextField.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.bottom).offset(60)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        nickNameEnterLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameModifyTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(28)
        }
    }
    private func finishModify() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(clickMoveUserPage))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func getImage(source image: UIImage) -> Void {
        let provider = MoyaProvider<ImageAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.uploadImage(data: image.jpegData(compressionQuality: 0.1) ?? Data())) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    print("성공")
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
}

extension UserModifyViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
            self.profileBackground.image = pickedImage
            self.dismiss(animated: true, completion: {
                self.getImage(source: pickedImage)
            })
        }
    }
    func loadImage() {
        let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.userInfoLoad) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(UserInfoResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            self.imageURL = data.profileImageURL
                            let url = URL(string: self.imageURL)
                            self.profileBackground.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
                            self.nickNameModifyTextField.placeholder = "\(data.nickname)"
                        }
                    } else {
                        print("fail")
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    @objc private func clickMoveUserPage() {
        guard let nickname = nickNameModifyTextField.text,
              !nickname.isEmpty
        else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.nickNameDuplicate(nickName: nickname)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    self.nicknameModify()
                case 409:
                    self.nickNameEnterLabel.text = "이미 사용 된 별명입니다."
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    private func nicknameModify() {
        guard let nickName = nickNameModifyTextField.text,
              !nickName.isEmpty
        else {return}
        let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.userInfoUpdate(userInfo: nickName)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    let alert = DefaultAlert(title: "별명이 변경되었습니다.")
                    self.present(alert, animated: true)
                    self.navigationController?.popViewController(animated: true)
                default:
                    self.nickNameEnterLabel.text = "별명을 확인하세요"
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
    @objc private func clickProfileModifyButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}
