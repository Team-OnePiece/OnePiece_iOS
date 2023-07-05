
import UIKit
import SnapKit
import Then

class IdCheckAlert: UIViewController {
    
    let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor(named: "darkGreen")?.cgColor
    }
    let lineView = UIView().then {
        $0.backgroundColor = .gray
    }
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    let closeButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setup()
    }
    
    func setup() {
        view.addSubview(alertView)
        [
            titleLabel,
            closeButton,
            lineView
        ].forEach({alertView.addSubview($0)})
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(140)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(47)
        }
        closeButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(17)
            $0.height.equalTo(44)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(33)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(1)
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    func alertMessage(title: String) {
        titleLabel.text = title
    }
}
