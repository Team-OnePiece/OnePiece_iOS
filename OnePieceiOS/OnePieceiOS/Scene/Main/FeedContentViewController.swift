//
//  FeedContentPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/06.
//

import UIKit
import SnapKit
import TagListView
import Then

class FeedContentViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate {
    private var count = 0
    private let cellIdentifier = "cellId"
    private var dataSource:[String] = []
    private let placeTextField = DefaultTextField(placeholder: "위치를 입력하세요").then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor(named: "mainColor-2")?.cgColor
    }
    private let explainLabel = UILabel().then {
        $0.text = "태그는 최대 6개, 최대 10자까지 작성 가능합니다."
        $0.textColor = .red
        $0.font = UIFont(name: "Orbit-Regular", size: 12)
    }
    private let placeTextFieldTextLengthLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = UIColor(named: "gray-500")
        $0.font = UIFont(name: "Orbit-Regular", size: 10)
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
    let tagListView = TagListView().then {
        $0.backgroundColor = .red
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        finishFeedWirte()
        placeTextField.delegate = self
        placeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.allEditingEvents)
        tagSetting()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    private func addSubViews() {
        [
            placeTextField,
            explainLabel,
            tagListView,
            groupChoiceLabel,
            groupChoiceButton
        ].forEach({view.addSubview($0)})
        placeTextField.addSubview(placeTextFieldTextLengthLabel)
    }
    private func makeConstraints() {
        placeTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(143)
            $0.left.right.equalToSuperview().inset(25)
        }
        placeTextFieldTextLengthLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7)
            $0.right.equalToSuperview().inset(10)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(25)
        }
        tagListView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(6)
            $0.height.equalTo(200)
            $0.left.right.equalToSuperview().inset(25)
        }
        groupChoiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(600)
            $0.left.equalToSuperview().inset(25)
        }
        groupChoiceButton.snp.makeConstraints {
            $0.top.equalTo(groupChoiceLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(25)
            $0.right.equalToSuperview().inset(165)
            $0.height.equalTo(38)
        }
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagListView.removeTagView(tagView)
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if tagView.titleLabel?.text == "+" {
            tagListView.addTag("fjsdkl")
            tagView.enableRemoveButton = false
            tagView.paddingX = 10
        }
    }
    func tagSetting() {
        tagListView.textFont = UIFont(name: "Orbit-Regular", size: 18)!
        tagListView.alignment = .left
        tagListView.borderWidth = 2
        tagListView.borderColor = UIColor(named: "mainColor-2")
        tagListView.tagBackgroundColor = .white
        tagListView.textColor = UIColor(named: "gray-700")!
        tagListView.marginX = 4
        tagListView.marginY = 8
        tagListView.paddingX = 30
        tagListView.enableRemoveButton = true
        tagListView.removeIconLineColor = UIColor(named: "gray-700")!
        tagListView.removeButtonIconSize = 6
        tagListView.addTag("+")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        return true
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        placeTextFieldTextLengthLabel.text = "\(String(placeTextField.text!.count))/10"
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace == -92 {
                    return true
                }
            }
            guard placeTextField.text!.count < 10 else { return false }
            return true
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

