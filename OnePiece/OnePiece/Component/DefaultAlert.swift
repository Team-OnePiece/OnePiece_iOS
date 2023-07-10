
import UIKit
import SnapKit
import Then

class DefaultAlert: UIViewController {
    
    let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
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
    
    init(
        title: String
    ) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(33)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(0.2)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(13)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
}
