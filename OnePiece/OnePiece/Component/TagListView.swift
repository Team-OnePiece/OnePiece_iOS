//
//  TagListView.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/25.
//

//import UIKit
//import SnapKit
//import Then
//
//class TagListView: UIView, UITextFieldDelegate {
//    
//    var dataSource: [String] = []
//    private let tagListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 8
//        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//        $0.register(TagListCell.self, forCellWithReuseIdentifier: "TagListCell")
//        $0.showsVerticalScrollIndicator = false
//        $0.collectionViewLayout = layout
//    }
//    private let tagPlusButton = UIButton(type: .system).then {
//        $0.setTitle("+", for: .normal)
//        $0.titleLabel?.font = UIFont(name: "Orbit-Regular", size: 32)
//        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
//        $0.backgroundColor = UIColor(named: "grya-000")
//        $0.layer.cornerRadius = 20
//        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
//        $0.layer.borderWidth = 2
//    }
//    
//    override init(frame: CGRect) {
//            super.init(frame: frame)
//        layout()
//        }
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    func layout() {
//        tagListCollectionView.delegate = self
//        addSubview(tagListCollectionView)
//        tagListCollectionView.addSubview(tagPlusButton)
//        tagPlusButton.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.left.equalToSuperview()
//            $0.height.equalTo(40)
//            $0.width.equalTo(100)
//        }
//        tagListCollectionView.snp.makeConstraints {
//            $0.top.bottom.left.equalToSuperview()
//        }
//    }
//}
//
//extension TagListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frame.width + 24, height: frame.height + 16)
//      }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagListCell", for: indexPath) as? TagListCell else {
//                    return UICollectionViewCell()
//        }
//        cell.tagTextField.text = dataSource[indexPath.row]
//        cell.tagTextField.delegate = self
//        cell.backgroundColor = .white
//        cell.layer.cornerRadius = 20
//        cell.layer.borderColor = UIColor.systemPink.cgColor
//        cell.layer.borderWidth = 2
//        return cell
//    }
//}
