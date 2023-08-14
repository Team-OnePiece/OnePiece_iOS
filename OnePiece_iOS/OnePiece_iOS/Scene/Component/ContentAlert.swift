import UIKit
import SnapKit
import Then
import Moya

class ContentAlert: UIViewController {
    
    private var deleteAction: () -> Void = {}
    let modifyButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제하기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        modifyButton.addTarget(self, action: #selector(clickModify), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        layout()
    }
    func layout() {
        [background].forEach({view.addSubview($0)})
        [modifyButton, deleteButton, line].forEach({background.addSubview($0)})
        
        background.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(160)
        }
        modifyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.left.right.equalToSuperview().inset(163)
        }
        line.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(0.7)
        }
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(31)
            $0.left.right.equalToSuperview().inset(163)
        }
    }
    @objc func clickModify() {
        //dismiss후에 push가 되게하는 법 찾아보기
            self.navigationController?.pushViewController(FeedModifyViewController(), animated: true)
            let feedModify = UIBarButtonItem(title: "피드 수정", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = feedModify
            self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
            feedModify.setTitleTextAttributes([
                .font: UIFont(name: "Orbit-Regular", size: 16)!
            ], for: .normal)
    }
    init(
//            useAction: @escaping () -> Void,
//            giftAction: @escaping () -> Void,
            deleteAction: @escaping () -> Void
        ) {
            super.init(nibName: nil, bundle: nil)
//            self.useAction = useAction
//            self.giftAction = giftActionm
            self.deleteAction = deleteAction
//            useButton.addTarget(self, action: #selector(useButtonClick), for: .touchUpInside)
//            giftButton.addTarget(self, action: #selector(giftButtonClick), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func clickDelete() {
        self.dismiss(animated: false, completion: { self.deleteAction() })
    }
}
