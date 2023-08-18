import UIKit
import SnapKit
import Then

class TagCollectionVIewCell: UICollectionViewCell {
    static let cellId = "TagCell"
    
    let tagLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-700")
        $0.backgroundColor = .white
        $0.font = UIFont(name: "Orbit-Regular", size: 9)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 1
        $0.textAlignment = .center
    }
    func tagSetter(
        tagList: String
    ) {
        self.tagLabel.text = tagList
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
