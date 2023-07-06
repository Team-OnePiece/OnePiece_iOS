//
//  CustomCell.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit

class CustomCell: UITableViewCell {

    static let cellId = "CellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
