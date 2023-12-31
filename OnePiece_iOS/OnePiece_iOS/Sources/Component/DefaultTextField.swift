import UIKit
import SnapKit
import Then

class DefaultTextField: UITextField {

    private var placeholderText: String = ""

    init(
        placeholder: String,
        isSecure: Bool = false
    ) {
        super.init(frame: .zero)
        self.placeholderText = placeholder
        self.font = UIFont.systemFont(ofSize: 16)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.isSecureTextEntry = isSecure
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftView = spacerView
        self.rightView = spacerView
        self.leftViewMode = .always
        self.rightViewMode = .always
        self.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        self.layer.borderWidth = 0.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        fieldSetting()
    }
    private func fieldSetting() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "gray-600")!,
                NSAttributedString.Key.font: UIFont(name: "Orbit-Regular", size: 16)!
            ]
        )
    }
}
