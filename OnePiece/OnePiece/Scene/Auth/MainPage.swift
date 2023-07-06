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
    let feedPlusButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedPlusIcon"), for: .normal)
        $0.backgroundColor = UIColor(named: "mainColor-1")
        $0.tintColor = .white
        $0.layer.cornerRadius = 40
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        feedPlusButton.addTarget(self, action: #selector(clickFeedPlus), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            mainLogo,
            mainLabel,
            tableView,
            feedPlusButton
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
        feedPlusButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.right.equalToSuperview().inset(30)
            $0.width.height.equalTo(80)
        }
    }
    @objc func clickFeedPlus() {
        self.navigationController?.pushViewController(FeedContentPage(), animated: true)
        let backButton = UIBarButtonItem(title: "피드 작성", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
}

extension MainPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
//        cell.textLabel?.text = cellArr[indexPath.row]
        return cell
    }
    
}

