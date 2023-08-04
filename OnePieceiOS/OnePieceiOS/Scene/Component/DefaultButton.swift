
import UIKit
import SnapKit
import Then

class DefaultButton: UIButton {
    
    private func commonSetup(title: String, backgroundColor: UIColor, titleColor: UIColor) {
        self.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 16)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 8
        self.alpha = 0.8
    }
    
    convenience init(type: UIButton.ButtonType, title: String, backgroundColor: UIColor, titleColor: UIColor) {
        self.init(type: type)
        commonSetup(title: title, backgroundColor: backgroundColor, titleColor: titleColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup(title: "", backgroundColor: .blue, titleColor: .white)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
