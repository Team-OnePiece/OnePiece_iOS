import UIKit
import SnapKit
import Then

class DetailSignupPage: UIViewController {

    let profileImage = UIImageView().then {
        $0.backgroundColor = .white
        $0.image = UIImage(named: "profile")
        $0.layer.cornerRadius = 80
//        $0.clipsToBounds = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseColor")
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            profileImage,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(109)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
        }
    }
}
