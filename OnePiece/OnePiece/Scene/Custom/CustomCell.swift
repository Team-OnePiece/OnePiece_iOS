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
    
    let profileImageView = UIImageView().then {
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
    let userSchoolNumber = UILabel().then {
        $0.text = "1401"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 8)
    }
    let dateLabel = UILabel().then {
        $0.text = "2023-02-28"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let feedSetting = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedSetting"), for: .normal)
        $0.tintColor = UIColor(named: "gray-800")
    }
    let feedImageView = UIImageView().then {
        $0.image = UIImage(named: "feedImage")
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubviews() {
        [
            profileImageView,
            userNameLabel,
            userSchoolNumber,
            dateLabel,
            feedSetting,
            feedImageView
        ].forEach({contentView.addSubview($0)})
    }
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(10)
            $0.height.width.equalTo(30)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.left.equalTo(profileImageView.snp.right).offset(3)
        }
        userSchoolNumber.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.left.equalTo(profileImageView.snp.right).offset(11)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(27)
        }
        feedSetting.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.left.equalTo(dateLabel.snp.right).offset(14)
        }
        feedImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(68)
        }
    }
}
