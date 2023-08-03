//
//  MainPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/02.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    private var cellArr: [String] =  []
    private let mainLogoImage = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    private let mainLabel = UILabel().then {
        $0.text = "어떤 하루를 보냈나요?"
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
        $0.textColor = UIColor(named: "gray-800")
    }
    private let groupButton = UIButton(type: .system).then {
        $0.setTitle("2023", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-500"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 20)
    }
    private let buttonAction = UIAction(title: "가보자고", handler: {_ in})
    private let Action = UIAction(title: "신기하네", handler: {_ in})
    private func clickPopup() {
        groupButton.menu = UIMenu(title: "ㅅㅂ", identifier: nil, options: .displayInline, children: [buttonAction, Action])
    }
    private let myPageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "setting"), for: .normal)
        $0.tintColor = UIColor(named: "settingColor")
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    private let feedPlusButton = UIButton(type: .system).then {
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
        clickPopup()
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    private func addSubViews() {
        [
            mainLogoImage,
            groupButton,
            mainLabel,
            myPageButton,
            tableView,
            feedPlusButton
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        mainLogoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        groupButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogoImage.snp.bottom).offset(31)
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
    private func moveView(targetView: UIViewController, title: String) {
        self.navigationController?.pushViewController(targetView, animated: true)
        let toMoveView = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = toMoveView
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        toMoveView.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }

    @objc private func clickFeedPlus() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc private func clickMyPage() {
        moveView(targetView: UserViewController(), title: "마이페이지")
    }
}

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {}
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.moveView(targetView: FeedContentViewController(), title: "피드 작성")
        }
    }
    func popupAlert() {
        let alert = ContentAlert()
        let navigationController = UINavigationController(rootViewController: alert)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    @objc func clickSetting() {
        popupAlert()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! CustomCell
        
        cell.feedSettingButton.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        return cell
    }
}

