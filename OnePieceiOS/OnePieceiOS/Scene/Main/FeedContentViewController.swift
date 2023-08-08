import UIKit
import SnapKit
import TagListView
import Then

class FeedContentViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var count = 0
    private let cellIdentifier = "cellId"
    private var dataSource:[String] = []
    private let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
    }
    private let explainLabel = UILabel().then {
        $0.text = "태그는 최대 6개, 최대 5자까지 작성 가능합니다."
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let placeTextFieldTextLengthLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = UIColor(named: "gray-500")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
    }
    private let tagTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 20
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 0))
        $0.leftView = spacerView
        $0.leftViewMode = .always
        $0.rightView = spacerView
        $0.rightViewMode = .always
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.attributedPlaceholder = NSAttributedString(
            string: "태그를 입력하세요.",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "gray-600")!,
                NSAttributedString.Key.font: UIFont(name: "Orbit-Regular", size: 16)!
            ]
        )
    }
    private let tagAddButton = UIButton(type: .system).then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 32)
    }
    private let tagListView = TagListView().then {
        $0.backgroundColor = .red
    }
    private let imageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    private let imageChoiceIcon = UIImageView(image: UIImage(named: "feedImageIcon"))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        finishFeedWirte()
        placeTextField.delegate = self
        placeTextField.addTarget(self, action: #selector(placeTextFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        tagTextField.delegate = self
        tagAddButton.addTarget(self, action: #selector(clickAddTag), for: .touchUpInside)
        tagSetting()
        clickImageView()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    func clickImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    @objc func touchToPickPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    private func addSubViews() {
        [
            placeTextField,
            explainLabel,
            tagListView,
            tagTextField,
            imageView,
        ].forEach({view.addSubview($0)})
        placeTextField.addSubview(placeTextFieldTextLengthLabel)
        tagTextField.addSubview(tagAddButton)
        imageView.addSubview(imageChoiceIcon)
    }
    private func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
        }
        placeTextFieldTextLengthLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(21)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(25)
        }
        tagTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(explainLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(25)
        }
        tagAddButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
        tagListView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(6)
            $0.height.equalTo(200)
            $0.left.right.equalToSuperview().inset(25)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(tagListView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(25)
            $0.width.height.equalTo(100)
            //레이아웃은 추후에 수정할 예정
        }
        imageChoiceIcon.snp.makeConstraints {
            $0.bottom.left.equalToSuperview().inset(3)
            $0.width.height.equalTo(20)
        }
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagListView.removeTagView(tagView)
    }
    func tagSetting() {
        tagListView.textFont = UIFont(name: "Orbit-Regular", size: 18)!
        tagListView.alignment = .left
        tagListView.borderWidth = 2
        tagListView.borderColor = UIColor(named: "mainColor-2")
        tagListView.tagBackgroundColor = .white
        tagListView.textColor = UIColor(named: "gray-700")!
        tagListView.marginX = 4
        tagListView.marginY = 8
        tagListView.delegate = self
        tagListView.paddingX = 13
        tagListView.paddingY = 11
        tagListView.cornerRadius = 20
        tagListView.enableRemoveButton = true
        tagListView.removeIconLineColor = UIColor(named: "gray-700")!
        tagListView.removeButtonIconSize = 6
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        return true
    }
    @objc private func placeTextFieldDidChange(_ textField: UITextField) {
        placeTextFieldTextLengthLabel.text = "\(String(placeTextField.text!.count))/10"
    }
    @objc private func clickAddTag() {
        tagListView.addTag("\(tagTextField.text!)")
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
    private func finishFeedWirte() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(finishFeed))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
    @objc private func finishFeed() {
        self.navigationController?.popViewController(animated: true)
        //여기서 서버통신~
    }
}

extension FeedContentViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {}
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imageView.image = img
        }
    }
}
