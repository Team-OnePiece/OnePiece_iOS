//
//  CustomCell.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit
import SnapKit
import Then

class CustomCell: UITableViewCell {

    static let cellId = "CellId"
    private var likeCount = 0
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "feedImage")
        $0.layer.cornerRadius = 15
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let userNameLabel = UILabel().then {
        $0.text = "멋진여성"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let userSchoolNumberLabel = UILabel().then {
        $0.text = "1401"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    private let dateLabel = UILabel().then {
        $0.text = "2023-02-28"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
    }
    let feedSettingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedSetting"), for: .normal)
        $0.tintColor = UIColor(named: "gray-800")
    }
    private let feedImageView = UIImageView().then {
        $0.image = UIImage(named: "feedImage")
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    private var isLiked = false
    private var likeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "dontLike"), for: .normal)
        $0.setImage(UIImage(named: "likeIcon"), for: .selected)
        $0.addTarget(self, action: #selector(clickLike), for: .touchUpInside)
    }
    private var countLikeLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    private let placeLabel = UILabel().then {
        $0.text = "몰라dfdssdf임마"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let tagCollectionView: UICollectionView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        addSubviews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        [
            profileImage,
            userNameLabel,
            userSchoolNumberLabel,
            dateLabel,
            feedSettingButton,
            feedImageView,
            likeButton,
            countLikeLabel,
            placeLabel,
            tagCollectionView
        ].forEach({contentView.addSubview($0)})
    }
    private func makeConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(10)
            $0.height.width.equalTo(30)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.left.equalTo(profileImage.snp.right).offset(3)
        }
        userSchoolNumberLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.left.equalTo(profileImage.snp.right).offset(11)
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
            $0.top.equalTo(countLikeLabel.snp.bottom).offset(7)
            $0.left.equalToSuperview().inset(12)
        }
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalTo(placeLabel.snp.right).offset(22)
            $0.right.equalToSuperview().inset(22)
        }
    }
    @objc private func clickLike() {
        isLiked.toggle()
        likeButton.isSelected = isLiked
        if likeButton.isSelected == true {
            likeCount += 1
            countLikeLabel.text = String(likeCount)
        } else if likeButton.isSelected == false {
            likeCount -= 1
            countLikeLabel.text = String(likeCount)
        }
    }
}

extension CustomCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionVIewCell
        cell.tagLabel.text = "fdjls"
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
        return 6
    }
}
