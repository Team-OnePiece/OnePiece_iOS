//
//  CustomCell.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit
import SnapKit
import Then
import Moya
import Kingfisher

class CustomCell: UITableViewCell {
    
    static let cellId = "CellId"
    var likeCount = 0
    var id: Int = 0
    let profileImage = UIImageView().then {
        $0.image = UIImage(named: "feedImage")
        $0.layer.cornerRadius = 15
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let userNameLabel = UILabel().then {
        $0.text = "멋진여성"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let gradeLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    let classnumberLabel = UILabel().then {
        $0.text = "4"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    let numberLabel = UILabel().then {
        $0.text = "01"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    let dateLabel = UILabel().then {
        $0.text = "2023-02-28"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
    }
    let feedSettingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedSetting"), for: .normal)
        $0.tintColor = UIColor(named: "gray-800")
        $0.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
    }
    let feedImageView = UIImageView().then {
        $0.image = UIImage(named: "feedImage")
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    var isLiked = false
    var likeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "dontLike"), for: .normal)
        $0.setImage(UIImage(named: "likeIcon"), for: .selected)
        $0.addTarget(self, action: #selector(clickLike), for: .touchUpInside)
    }
    var countLikeLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    let placeLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(TagCollectionVIewCell.self, forCellWithReuseIdentifier: "TagCell")
        return collectionView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        addSubviews()
        makeConstraints()
    }
    func addSubviews() {
        [
            profileImage,
            userNameLabel,
            gradeLabel,
            classnumberLabel,
            numberLabel,
            dateLabel,
            feedSettingButton,
            feedImageView,
            likeButton,
            countLikeLabel,
            placeLabel,
            tagCollectionView
        ].forEach({contentView.addSubview($0)})
    }
    func makeConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(10)
            $0.height.width.equalTo(30)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.left.equalTo(profileImage.snp.right).offset(3)
        }
        gradeLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.left.equalTo(profileImage.snp.right).offset(3)
        }
        classnumberLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.left.equalTo(gradeLabel.snp.right)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.left.equalTo(classnumberLabel.snp.right)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(27)
        }
        feedSettingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalTo(dateLabel.snp.right).offset(14)
        }
        feedImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(68)
        }
        likeButton.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(18)
            $0.left.equalToSuperview().inset(12)
        }
        countLikeLabel.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(18)
            $0.left.equalTo(likeButton.snp.right).offset(8)
        }
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(countLikeLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview().inset(12)
        }
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(120)
            $0.right.equalToSuperview().inset(22)
        }
    }
    @objc func clickLike() {
        isLiked.toggle()
        likeButton.isSelected = isLiked
        if likeButton.isSelected == true {
            AddlikeAction?()
            countLikeLabel.text = String(likeCount)
        } else if likeButton.isSelected == false {
            deleteLikeAction?()
            countLikeLabel.text = String(likeCount)
        }
    }
    @objc func clickSetting() {
        moveSettingView?()
    }
    var AddlikeAction: (() -> Void)?
    var deleteLikeAction: (() -> Void)?
    var moveSettingView: (() -> Void)?
    public func cellSetter(
        id: Int,
        nickname: String,
        place: String,
        profileImage: String,
        feedImage: String,
        feedDate: String,
        grade: String,
        classnumber: String,
        number: String
    ) {
        self.id = id
        self.userNameLabel.text = nickname
        self.placeLabel.text = place
        self.dateLabel.text = feedDate
        self.feedImageView.kf.setImage(with: URL(string: feedImage))
        self.profileImage.kf.setImage(with: URL(string: profileImage), placeholder: UIImage(named: "profile"))
        self.gradeLabel.text = String(grade)
        self.classnumberLabel.text = String(classnumber)
        self.numberLabel.text = String(number)
    }
    let tagList: [TagModel] = []
}


extension CustomCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionVIewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = 50
        let heightCell = 20
        return CGSize(width: widthCell, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
}
