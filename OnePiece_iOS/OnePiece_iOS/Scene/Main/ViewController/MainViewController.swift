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
    private let homeLabel = UILabel().then {
        $0.text = "홈"
        $0.textColor = .black
        $0.font = UIFont(name: "Orbit-Regular", size: 16)
    }
    private let myPageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "setting"), for: .normal)
        $0.tintColor = UIColor(named: "settingColor")
        $0.addTarget(self, action: #selector(clickMyPage), for: .touchUpInside)
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = true
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
            homeLabel,
            mainLabel,
            myPageButton,
            tableView,
            feedPlusButton
        ].forEach({view.addSubview($0)})
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
        homeLabel.snp.makeConstraints {
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
    @objc private func clickFeedPlus() {
        self.moveView(targetView: FeedContentViewController(), title: "피드 작성")
    }
    
    @objc private func clickMyPage() {
        self.moveView(targetView: UserViewController(), title: "마이페이지")
    }
    @objc func pullToRefresh() {
        loadFeed()
    }
    func likeFeed(feedId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let provider = MoyaProvider<StarAPI>(plugins: [MoyaLoggerPlugin()])
        provider.request(.addStar(feedId: feedId)) { result in
            switch result {
            case .success:
                completion(.success(())) // 좋아요 요청 성공
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    @objc func clickSetting() {
//        popup()
//    }
//    func popup() {
//        let alert = ContentAlert(deleteAction: { let deleteModal = FeedDeleteAlert(id: self.feedList[IndexPath().row].id, completion: {
//            self.feedList.remove(at: IndexPath().row)
//            self.tableView.reloadData()
//        })
//            self.present(deleteModal, animated: false)})
//        let navigationController = UINavigationController(rootViewController: alert)
//        navigationController.modalPresentationStyle = .overFullScreen
//        self.present(navigationController, animated: true, completion: nil)
//    }
    var data: Data = Data()
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func clickAddLike(indexPath: IndexPath) {
        let selectedFeed = feedList[indexPath.row] // 예시: feedList는 피드 배열
        let feedId = selectedFeed.id
            likeFeed(feedId: feedId) { result in
                switch result {
                case .success:
                    print("성공")
                case .failure(let error):
                    print("Failed to like feed: \(error)")
                }
            }
    }
    func clickDeleteLike(indexPath: IndexPath) {
        let selectedFeed = feedList[indexPath.row] // 예시: feedList는 피드 배열
        let feedId = selectedFeed.id
            likeFeed(feedId: feedId) { result in
                switch result {
                case .success:
                    print("성공")
                case .failure(let error):
                    print("Failed to like feed: \(error)")
                }
            }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId") as? CustomCell else {return UITableViewCell()}
        //                cell.feedSettingButton.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        cell.AddlikeAction = { [weak self] in
            if let data = try? JSONDecoder().decode(AddStarResponse.self, from: self!.data) {
                self?.clickAddLike(indexPath: indexPath)
                cell.likeCount = data.starCount
                cell.countLikeLabel.text = String(cell.likeCount)
            }
        }
        cell.deleteLikeAction = { [weak self] in
            if let data = try? JSONDecoder().decode(DeleteStarResponse.self, from: self!.data) {
                self?.clickDeleteLike(indexPath: indexPath)
                cell.likeCount = data.starCount
                cell.countLikeLabel.text = String(cell.likeCount)
            }
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = ContentAlert(
            modifyAction: { let modifyModal = FeedModifyViewController(id: self.feedList[indexPath.row].id, completion: {
                self.tableView.reloadData()
            })
                self.navigationController?.pushViewController(modifyModal, animated: true)
                let feedModify = UIBarButtonItem(title: "피드 수정", style: .plain, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = feedModify
                self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "gray-800")
                feedModify.setTitleTextAttributes([
                    .font: UIFont(name: "Orbit-Regular", size: 16)!
                ], for: .normal)
            },
            deleteAction: { let deleteModal = FeedDeleteAlert(id: self.feedList[indexPath.row].id, completion: {
                self.feedList.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
                self.present(deleteModal, animated: false)})
        let navigationController = UINavigationController(rootViewController: alert)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

