//
//  MainPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/02.
//

import UIKit
import SnapKit
import Then

class MainPage: UIViewController, UINavigationControllerDelegate {
    
    var cellArr: [String] =  []
    let mainLogo = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    let mainLabel = UILabel().then {
        $0.text = "어떤 하루를 보냈나요?"
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
        $0.textColor = UIColor(named: "gray-800")
    }
    let myPageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "setting"), for: .normal)
        $0.tintColor = UIColor(named: "settingColor")
    }
    let tableView = UITableView().then {
        $0.backgroundColor = .white
    }
    let feedPlusButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedPlusIcon"), for: .normal)
        $0.backgroundColor = UIColor(named: "mainColor-1")
        $0.tintColor = UIColor(named: "gray-200")
        $0.layer.cornerRadius = 40
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.rowHeight = 408
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationItem.hidesBackButton = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CellId")
        feedPlusButton.addTarget(self, action: #selector(clickFeedPlus), for: .touchUpInside)
        myPageButton.addTarget(self, action: #selector(clickMyPage), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    func addSubViews() {
        [
            mainLogo,
            mainLabel,
            myPageButton,
            tableView,
            feedPlusButton
        ].forEach({view.addSubview($0)})
    }
    func makeConstraints() {
        mainLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogo.snp.bottom).offset(31)
            $0.left.right.equalToSuperview().inset(45)
        }
        myPageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom)
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
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc func clickMyPage() {
        self.navigationController?.pushViewController(UserPage(), animated: true)
        let mainPageBackbutton = UIBarButtonItem(title: "마이페이지", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = mainPageBackbutton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        mainPageBackbutton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }

}


extension MainPage: UIImagePickerControllerDelegate {
//     이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
    // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.navigationController?.pushViewController(FeedContentPage(), animated: true)
            let backButton = UIBarButtonItem(title: "피드 작성", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
            backButton.setTitleTextAttributes([
                .font: UIFont(name: "Orbit-Regular", size: 16)
            ], for: .normal)
        }
    }
}

extension MainPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! CustomCell
        //        cell.textLabel?.text = cellArr[indexPath.row]
        return cell
    }
}

