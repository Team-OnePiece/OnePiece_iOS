import UIKit
import SnapKit
import Then
import Moya
import Kingfisher

class UserViewController: UIViewController {
    
    private var imageURL: String = ""
    private let profileBackground = UIImageView(image: UIImage(named: "profile")).then {
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    private let messageLabel = UILabel().then {
        $0.text = "00님,\n오늘은\n어떤 하루를 보냈나요?"
        $0.numberOfLines = 3
        $0.textAlignment = .center
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "gray-800")
    }
    private let modifyButton = DefaultButton(type: .system, title: "수정하기", backgroundColor: .white, titleColor: UIColor(named: "gray-700")!).then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        modifyButton.addTarget(self, action: #selector(clickModifyPage), for: .touchUpInside)
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
            messageLabel,
            modifyButton
        ].forEach({view.addSubview($0)})
        
        profileBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(profileBackground.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
        }
        modifyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(61)
            $0.left.right.equalToSuperview().inset(25)
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
                            self.messageLabel.text = "\(data.nickname)님,\n오늘은\n어떤 하루를 보냈나요?"
                            let url = URL(string: self.imageURL)
                            self.profileBackground.kf.setImage(with: url, placeholder: UIImage(named: "profileImage"))
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
    
    @objc private func clickModifyPage() {
        self.navigationController?.pushViewController(UserModifyViewController(), animated: true)
        let myPageBackbutton = UIBarButtonItem(title: "프로필 수정", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = myPageBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        myPageBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
}
