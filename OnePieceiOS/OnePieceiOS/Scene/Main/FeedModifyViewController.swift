import UIKit
import SnapKit
import Then

class FeedModifyViewController: UIViewController, UITextFieldDelegate {
    private var count = 0
    private let cellIdentifier = "cellId"
    private var dataSource:[String] = []
    private let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
    }
    private let explainLabel = UILabel().then {
        $0.text = "태그는 최대 6개, 최대 10자까지 작성 가능합니다."
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let placeTextFieldTextLengthLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = UIColor(named: "gray-500")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        placeTextField.delegate = self
        placeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        finishFeedModify()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    private func addSubViews() {
        [
            placeTextField,
            explainLabel
        ].forEach({view.addSubview($0)})
        placeTextField.addSubview(placeTextFieldTextLengthLabel)
    }
    private func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
        }
        placeTextFieldTextLengthLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7)
            $0.right.equalToSuperview().inset(10)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(25)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        return true
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        placeTextFieldTextLengthLabel.text = "\(String(placeTextField.text!.count))/10"
    }
    private func finishFeedModify() {
        let finishButotn = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(clickFinishFeedModify))
        self.navigationItem.rightBarButtonItem = finishButotn
        finishButotn.tintColor = UIColor(named: "gray-800")
        finishButotn.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
    @objc private func clickFinishFeedModify() {
        self.navigationController?.popViewController(animated: true)
        //여기서 서버통신
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace == -92 {
                    return true
                }
            }
            guard placeTextField.text!.count < 10 else { return false }
            return true
        }
}

