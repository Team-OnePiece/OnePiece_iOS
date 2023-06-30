import UIKit
import SnapKit
import Then

class StartingPage: UIViewController {

    let sloganLabel = UILabel().then {
        $0.text = "단 한장의 사진으로"
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "charcoal")
    }
    let titleLabel = UILabel().then {
        $0.text = "One Piece"
        $0.font = UIFont(name: "Orbit-Regular", size: 36)
        $0.textColor = .black
    }
    let mainIcon = UIImageView().then {
        $0.image = UIImage(named: "mainIcon")
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
            sloganLabel,
            titleLabel,
            mainIcon,
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
    //MARK: 디자인 수정되면 다시 레이아웃 잡기
        sloganLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(198)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sloganLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        mainIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(326)
            $0.bottom.equalToSuperview().inset(363.7)
            $0.left.right.equalToSuperview().inset(115)
        }
    }
}

