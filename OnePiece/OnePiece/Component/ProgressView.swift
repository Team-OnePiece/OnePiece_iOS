//
//  ProgressView.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/16.
//

import UIKit
import SnapKit
import Then

class ProgressView: UIView {
    let cir1 = UIView().then {
        $0.backgroundColor = UIColor(named: "mainColor-1")
    }
    let cir2 = UIView().then {
        $0.backgroundColor = UIColor(named: "mainColor-2")
    }
    let cir3 = UIView().then {
        $0.backgroundColor = UIColor(named: "mainColor-2")
    }
    let cir4 = UIView().then {
        $0.backgroundColor = UIColor(named: "mainColor-2")
    }
    let cirtitle1 = UILabel().then {
        $0.text = "1"
        $0.textColor = UIColor(named: "gray-000")
    }
    let cirtitle2 = UILabel().then {
        $0.text = "2"
        $0.textColor = UIColor(named: "gray-000")
    }
    let cirtitle3 = UILabel().then {
        $0.text = "3"
        $0.textColor = UIColor(named: "gray-000")
    }
    let cirtitle4 = UILabel().then {
        $0.text = "4"
        $0.textColor = UIColor(named: "gray-000")
    }
    let line1 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-500")
    }
    init(
        cir1Color: String,
        cir2Color: String,
        cir3Color: String,
        cir4Color: String
    ) {
        super.init()
        cir1.backgroundColor = cir1Color
        cir2.backgroundColor = cir2Color
        cir3.backgroundColor = cir3Color
        cir4.backgroundColor = cir4Color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        makeConstraints()
    }
    override func addSubview(_ view: UIView) {
        [
            cir1,
            cir2,
            cir3,
            cir4
        ].forEach({view.addSubview($0)})
        cir1.addSubview(cirtitle1)
        cir2.addSubview(cirtitle2)
        cir3.addSubview(cirtitle3)
        cir4.addSubview(cirtitle4)
    }
    func makeConstraints() {
        
    }
}
