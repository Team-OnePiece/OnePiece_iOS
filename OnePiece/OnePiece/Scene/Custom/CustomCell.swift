//
//  CustomCell.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit

class CustomCell: UITableViewCell {

    static let cellId = "CellId"
    
//    let feedImageView
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubviews()
        makeConstraints()
    }
//    func addSubviews() {
//        [
//        ]
//    }
    func makeConstraints() {
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
