import UIKit
import SnapKit
import Then

class GroupViewController: UIViewController {

    let backgroud = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 12
    }
    let GradeLabel = UIButton(type: .system).then  {
        $0.setTitle("1학년", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let classButton = UIButton(type: .system).then {
        $0.setTitle("1-1", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let lineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-500")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    override func viewWillLayoutSubviews() {
        makeConstraints()
    }
    func makeConstraints() {
        view.addSubview(backgroud)
        [
            GradeLabel,
            classButton,
            lineView
        ].forEach({backgroud.addSubview($0)})
        backgroud.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(70)
        }
        GradeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(GradeLabel.snp.bottom).offset(3)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(0.2)
        }
        classButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
    }
}
