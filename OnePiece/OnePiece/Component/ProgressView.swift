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
    let line2 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-500")
    }
    let line3 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-500")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
//        makeConstraints()
    }
    func makeConstraints() {
        [
            cir1,
            cir2,
            cir3,
            cir4,
            line1,
            line2,
            line3
        ].forEach({addSubview($0)})
        cir1.addSubview(cirtitle1)
        cir2.addSubview(cirtitle2)
        cir3.addSubview(cirtitle3)
        cir4.addSubview(cirtitle4)
        cir1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
        }
        cir2.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalTo(line1.snp.right)
        }
        cir3.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalTo(line2.snp.right)
        }
        cir4.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalTo(line3.snp.right)
        }
        line1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalToSuperview().inset(16.92)
            $0.left.equalTo(cir1.snp.right)
        }
        line2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalToSuperview().inset(16.92)
            $0.left.equalTo(cir2.snp.right)
        }
        line3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalToSuperview().inset(16.92)
            $0.left.equalTo(cir3.snp.right)
        }
    }
}
