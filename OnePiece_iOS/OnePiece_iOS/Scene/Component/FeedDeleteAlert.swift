import UIKit
import SnapKit
import Then
import Moya

class FeedDeleteAlert: UIViewController {
    
    private let background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    private let deleteLabel = UILabel().then {
        $0.text = "삭제하시겠습니까?"
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    private let warningLabel = UILabel().then {
        $0.text = "다시 돌이킬 수 없습니다."
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    private let lineView1 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let lineView2 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.addTarget(self, action: #selector(clickCancelDeleteFeed), for: .touchUpInside)
    }
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        $0.addTarget(self, action: #selector(clickDeleteFeed), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

    }
    override func viewWillLayoutSubviews() {
        layout()
    }
    private func layout() {
        view.addSubview(background)
        [
            deleteLabel,
            warningLabel,
            lineView1,
            lineView2,
            cancelButton,
            deleteButton
        ].forEach({background.addSubview($0)})
        
        background.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(150)
        }
        deleteLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.centerX.equalToSuperview()
        }
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(deleteLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        lineView1.snp.makeConstraints {
            $0.top.equalTo(warningLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(0.5)
        }
        lineView2.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom)
            $0.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(0.5)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(58)
        }
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(58)
        }
    }
    private var completion: () -> Void = {}
    private var id: Int = 0
    init(id: Int, completion: @escaping () -> Void) {
           super.init(nibName: nil, bundle: nil)
           self.id = id
           self.completion = completion
           self.modalPresentationStyle = .overFullScreen
           
       }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    @objc private func clickCancelDeleteFeed() {
        self.dismiss(animated: true)
    }
    @objc func clickDeleteFeed() {
        self.dismiss(animated: true)
        let provider = MoyaProvider<FeedAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.deleteFeed(feedId: self.id)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 204:
                    self.completion()
                    print("성공")
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
