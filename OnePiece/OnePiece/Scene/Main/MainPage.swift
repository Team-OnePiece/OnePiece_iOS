//
//  MainPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/02.
//

import UIKit
import SnapKit
import Then

class MainPage: UIViewController {

    var cellArr: [String] =  []
    let mainLogo = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    let mainLabel = UILabel().then {
        $0.text = "어떤 하루를 보냈나요?"
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
        $0.textColor = UIColor(named: "gray-800")
    }
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor(named: "mainColor-3")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor-3")
        navigationItem.hidesBackButton = true
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    func addSubViews() {
        [
            mainLogo,
            mainLabel,
            tableView
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        mainLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(59)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(133)
            $0.left.right.equalToSuperview().inset(27)
        }
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(155)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(27)
        }
    }
}
