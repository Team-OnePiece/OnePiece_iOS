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
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        sloganLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(198)
            //디자인 수정되면 다시 수정하기
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sloganLabel.snp.bottom).offset(10)
            //디자인 수정되면 다시 수정하기
            $0.centerX.equalToSuperview()
        }
    }
}

