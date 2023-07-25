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
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let feedSettingButton = UIButton(type: .system).then {
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
    }
    private var countLikeLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    private let placeLabel = UILabel().then {
        $0.text = "몰라임마"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        feedSettingButton.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(clikcLike), for: .touchUpInside)
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
            placeLabel
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
    }
    @objc private func clickSetting() {
        let alert = ContentAlert()
        alert.modalPresentationStyle = .overFullScreen
        //UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        //선배님이 보여주신 코드 수정하기
    }
    @objc private func clikcLike() {
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
