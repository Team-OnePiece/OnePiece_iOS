import UIKit
import SnapKit
import Then

class StartingPage: UIViewController {

    let sloganLabel = UILabel().then {
        $0.text = "단 한장의 사진으로"
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.textColor = UIColor(named: "charcoal")
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
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        sloganLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(198)
            $0.centerX.equalToSuperview()
        }
    }
}

