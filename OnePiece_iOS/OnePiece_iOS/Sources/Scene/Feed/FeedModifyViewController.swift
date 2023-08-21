import UIKit
import SnapKit
import Then
import Moya

class FeedModifyViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var completion: () -> Void = {}
    private var id: Int = 0
    private var count = 0
    private let cellIdentifier = "cellId"
    private var dataSource:[String] = []
    private let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
    }
    private let placeTextFieldTextLengthLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = UIColor(named: "gray-500")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
    }
    private let imageView = UIImageView()
    private let photoImage = UIImageView(image: UIImage(named: "baseImage"))
    private let imageChoiceIcon = UIImageView(image: UIImage(named: "feedImageIcon"))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        placeTextField.delegate = self
        finishFeedModify()
        clickImageView()
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
            imageView
        ].forEach({view.addSubview($0)})
        placeTextField.addSubview(placeTextFieldTextLengthLabel)
        imageView.addSubview(imageChoiceIcon)
        imageView.addSubview(photoImage)
    }
    private func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        placeTextFieldTextLengthLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7)
            $0.right.equalToSuperview().inset(10)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(60)
            $0.left.equalToSuperview().inset(25)
            $0.width.height.equalTo(100)
        }
        photoImage.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        imageChoiceIcon.snp.makeConstraints {
            $0.bottom.left.equalToSuperview().inset(3)
            $0.width.height.equalTo(20)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        return true
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        placeTextFieldTextLengthLabel.text = "\(String(placeTextField.text!.count))/10"
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
    init(id: Int, completion: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.completion = completion
        self.modalPresentationStyle = .overFullScreen
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        guard let place = placeTextField.text,
              let image = imageView.image,
              !place.isEmpty || image == nil else {return}
        let provider = MoyaProvider<FeedAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.modifyFeed(data: image.jpegData(compressionQuality: 0.1) ?? Data(), place: place, feedId: self.id)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    print("성공")
                    self.navigationController?.popViewController(animated: true)
                default:
                    print("실패")
                    let alert = DefaultAlert(title: "게시물 수정에 실패하였습니다.")
                    self.present(alert, animated: true)
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
extension FeedModifyViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {}
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imageView.image = img
            self.photoImage.isHidden = true
            self.imageChoiceIcon.isHidden = true
        }
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
}
