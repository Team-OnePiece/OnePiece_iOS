//
//  MainPage.swift
//  OnePiece
//
//  Created by 조영준 on 2023/07/02.
//

import UIKit
import SnapKit
import Then
import Moya
import Kingfisher

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    private var profileURL: String = ""
    private var feedURL: String = ""
    private var feedList: [FeedModel] = [] {
        didSet {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    private let refreshControl = UIRefreshControl()
    private let feedEmptyLabel = UILabel().then {
        $0.text = "게시물을 작성해보세요"
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 30)
    }
    private let mainLogoImage = UIImageView().then {
        $0.image = UIImage(named: "mainLogo")
    }
    private let mainLabel = UILabel().then {
        $0.text = "어떤 하루를 보냈나요?"
        $0.font = UIFont(name: "Orbit-Regular", size: 14)
        $0.textColor = UIColor(named: "gray-800")
    }
    private let groupStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 10
    }
    private let groupLabel = UILabel().then {
        $0.text = "1학년"
        $0.textColor = UIColor(named: "gray-500")
        $0.font = UIFont(name: "Orbit-Regular", size: 20)
    }
    private let groupChoiceIcon = UIImageView(image: UIImage(named: "groupIcon"))
    private let myPageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "setting"), for: .normal)
        $0.tintColor = UIColor(named: "settingColor")
        $0.addTarget(self, action: #selector(clickMyPage), for: .touchUpInside)
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 408
        $0.register(CustomCell.self, forCellReuseIdentifier: "CellId")
        $0.separatorStyle = .none
    }
    private let feedPlusButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feedPlusIcon"), for: .normal)
        $0.backgroundColor = UIColor(named: "mainColor-1")
        $0.tintColor = UIColor(named: "gray-200")
        $0.layer.cornerRadius = 40
        $0.addTarget(self, action: #selector(clickFeedPlus), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        clickGroup()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    override func viewWillLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFeed()
    }
    private func addSubViews() {
        [
            feedEmptyLabel,
            mainLogoImage,
            groupStackView,
            mainLabel,
            myPageButton,
            tableView,
            feedPlusButton
        ].forEach({view.addSubview($0)})
        [groupChoiceIcon, groupLabel].forEach({groupStackView.addArrangedSubview($0)})
    }
    private func makeConstraints() {
        feedEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        mainLogoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        groupStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        groupChoiceIcon.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(12)
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
    func loadFeed() {
        let provider = MoyaProvider<FeedAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.loadFeed) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(FeedResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            self.feedList = data.map {
                                .init(
                                    id: $0.id,
                                    nickname: $0.nickname,
                                    profileImage: $0.feedProfileImageurl,
                                    grade: $0.grade,
                                    classnumber: $0.classnumber,
                                    number: $0.number,
                                    feedImage: $0.feedImageurl,
                                    place: $0.place,
                                    feedDate: $0.feedDate
                                )
                            }
                            self.feedList.sort(by: { $0.id > $1.id })
                        }
                    } else {
                        print("실패")
                    }
                default:
                    print("실패")
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
    private func moveView(targetView: UIViewController, title: String) {
        self.navigationController?.pushViewController(targetView, animated: true)
        let toMoveView = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = toMoveView
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
        toMoveView.setTitleTextAttributes([
            .font: UIFont(name: "Orbit-Regular", size: 16)!
        ], for: .normal)
    }
    private func clickGroup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPopupGroupAlert))
        groupStackView.addGestureRecognizer(tapGesture)
        groupStackView.isUserInteractionEnabled = true
    }
    @objc private func clickFeedPlus() {
        self.moveView(targetView: FeedContentViewController(), title: "피드 작성")
    }
    
    @objc private func clickMyPage() {
        self.moveView(targetView: UserViewController(), title: "마이페이지")
    }
    @objc private func clickPopupGroupAlert() {
        let group = GroupViewController()
        group.modalPresentationStyle = .overFullScreen
        group.modalTransitionStyle = .crossDissolve
        self.present(group, animated: true)
    }
    @objc func pullToRefresh() {
          loadFeed()
      }
}

extension MainViewController {
    func popupAlert() {
        let alert = ContentAlert()
        let navigationController = UINavigationController(rootViewController: alert)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    @objc func clickSetting() {
        popupAlert()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId") as? CustomCell else {return UITableViewCell()}
        cell.feedSettingButton.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        cell.cellSetter(
            id: feedList[indexPath.row].id,
            nickname: feedList[indexPath.row].nickname,
            place: feedList[indexPath.row].place,
            profileImage: feedList[indexPath.row].profileImage,
            feedImage: feedList[indexPath.row].feedImage,
            feedDate: feedList[indexPath.row].feedDate,
            grade: "\(feedList[indexPath.row].grade)",
            classnumber: "\(feedList[indexPath.row].classnumber)",
            number: "\(feedList[indexPath.row].number)"
        )
        cell.selectionStyle = .none
        return cell
    }
}

