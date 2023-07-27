//
//  FeedContentPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit
import SnapKit
import Then

class FeedContentViewController: UIViewController {
    
    let cellIdentifier = "cellId"
    var dataSource:[String] = []
    private let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
    }
    private let explainLabel = UILabel().then {
        $0.text = "태그는 최대 6개, 최대 10자까지 작성 가능합니다."
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        //        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        $0.register(TagListCell.self, forCellWithReuseIdentifier: "TagListCell")
        $0.showsVerticalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.backgroundColor = .gray
    }
    //    let collectionView = TagListView()
    private let tagPlusButton = UIButton(type: .system).then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 32)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.backgroundColor = UIColor(named: "gray-000")
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
    }
    private let groupChoiceLabel = UILabel().then {
        $0.text = "어느 그룹에 업로드 하시겠습니까?"
        $0.textColor = UIColor(named: "gray-900")
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let groupChoiceButton = UIButton(type: .system).then {
        $0.setTitle("2023", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 20)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
        $0.layer.borderWidth = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        finishFeedWirte()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagListCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    private func addSubViews() {
        [
            placeTextField,
            collectionView,
            explainLabel,
            groupChoiceLabel,
            groupChoiceButton
        ].forEach({view.addSubview($0)})
        collectionView.addSubview(tagPlusButton)
    }
    private func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(25)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(200)
        }
        groupChoiceLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(56)
            $0.left.equalToSuperview().inset(25)
        }
        groupChoiceButton.snp.makeConstraints {
            $0.top.equalTo(groupChoiceLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(165)
            $0.height.equalTo(38)
        }
        tagPlusButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(50)
            $0.top.left.equalToSuperview().inset(3)
        }
    }
    private func finishFeedWirte() {
        let finishButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(finishFeed))
        self.navigationItem.rightBarButtonItem = finishButton
        finishButton.tintColor = UIColor(named: "gray-800")
        finishButton.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)
        ], for: .normal)
    }
    @objc private func finishFeed() {
        self.navigationController?.popViewController(animated: true)
        //여기서 서버통신~
    }
}

extension FeedContentViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TagListCell else {
            return UICollectionViewCell()}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}
