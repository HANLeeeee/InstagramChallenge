//
//  FeedViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/31.
//

import UIKit
import Kingfisher
import YPImagePicker
import FloatingPanel

class FeedViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()
    var feedsResult = [FeedResponseResult]()    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnNewPost: UIButton!
    
    var pickImage = UIImage()
    var pageIndex = 0
    var size = 10
    
    var modifyIndex = 0

    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedViewController()
        registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //피드초기화
        pageIndex = 0
        feedsResult.removeAll()
        getFeedInfo(pageIdx: pageIndex)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUIFeedViewController() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func getFeedInfo(pageIdx: Int) {
        APIFeedGet().getFeeds(accessToken: userToken.jwt!, pageIndex: pageIdx, size: size) { result in
            switch result {
            case .success(let feedsResult):
                if self.pageIndex == 0 {
                    self.feedsResult = feedsResult
                } else {
                    self.feedsResult += feedsResult
                }
                self.feedTableView.reloadData()
                self.refreshControl.endRefreshing()

            case .failure(let error):
                print(error)
            }
        }
    }

    func registerTableView() {
        let storytableViewCellNib = UINib(nibName: "StoryTableViewCell", bundle: nil)
        self.feedTableView.register(storytableViewCellNib, forCellReuseIdentifier: "StoryTableViewCell")
        
        let feedtableViewCellNib = UINib(nibName: "FeedTableViewCell", bundle: nil)
        self.feedTableView.register(feedtableViewCellNib, forCellReuseIdentifier: "FeedTableViewCell")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        feedTableView.separatorStyle = .none
        
        refreshControl.endRefreshing()
        feedTableView.refreshControl = refreshControl
    }
    
    func setNavigationBackBtn() {
        let backBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: nil)
        backBarButtonItem.tintColor = .black  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GoFeedNewViewController":
            let feedNewVC = segue.destination as! FeedNewViewController
            feedNewVC.pickImage = self.pickImage
            
        case "GoFeedModifyViewController":
            let feedModifyVC = segue.destination as! FeedModifyViewController
            feedModifyVC.feedID = feedsResult[modifyIndex].feedId!
            feedModifyVC.userID = feedsResult[modifyIndex].feedLoginId!
            feedModifyVC.modifyImageURL = feedsResult[modifyIndex].contentsList![0].contentsUrl!
            feedModifyVC.modifyText = feedsResult[modifyIndex].feedText!
            
        case "GoFeedCommentsViewController":
            let feedCommentsVC = segue.destination as! FeedCommentsViewController
            feedCommentsVC.feedIdx = feedsResult[modifyIndex].feedId!
            feedCommentsVC.userID = feedsResult[modifyIndex].feedLoginId!
            feedCommentsVC.commentsText = feedsResult[modifyIndex].feedText ?? ""
            feedCommentsVC.commentsfeedDate = feedsResult[modifyIndex].feedCreatedAt!
            
        default:
            return
        }
    }
}



//MARK: 테이블뷰
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
        
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            pageIndex = 0
            feedsResult.removeAll()
            getFeedInfo(pageIdx: pageIndex)
        } else if self.feedTableView.contentOffset.y > feedTableView.contentSize.height-feedTableView.bounds.size.height {
            pageIndex += 1
            getFeedInfo(pageIdx: pageIndex)
            self.feedTableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return feedsResult.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as! StoryTableViewCell

            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
            cell.cellIndex = indexPath.row
            cell.btnMoreDelegate = self

            setCellValue(cell: cell, indexPath: indexPath)

            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 120

        case 1:
            return UITableView.automaticDimension

        default:
            return UITableView.automaticDimension
        }
    }
    
    func setCellValue(cell: FeedTableViewCell, indexPath: IndexPath) {
        let likecount = Int.random(in: 0...30000)
        cell.labelLikeCount.text = "좋아요 \(numberFormatter(number: likecount))개"

        cell.labelfeedLoginId.text = feedsResult[indexPath.row].feedLoginId!
        cell.labelfeedIdplusText.text = "\(feedsResult[indexPath.row].feedLoginId!)  \(feedsResult[indexPath.row].feedText!)"
        cell.labelfeedCreatedAt.text = dateSub(date: feedsResult[indexPath.row].feedCreatedAt!)
        cell.labelfeedCommentCount.text = "댓글 \(feedsResult[indexPath.row].feedCommentCount!)개 모두보기"
            
        guard let imageUrl = URL(string: self.feedsResult[indexPath.row].contentsList![0].contentsUrl!) else {
            cell.imageViewFeed.image = UIImage()
            return }
        cell.imageViewFeed.kf.setImage(with: imageUrl)
        
        if feedsResult[indexPath.row].feedLoginId == userToken.loginId {
            cell.btnMore.isHidden = false
        } else {
            cell.btnMore.isHidden = true
        }
    }
}



//MARK: 액션이벤트
extension FeedViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNewPost:
            imagePicker()
            
        default:
            return
        }
        
    }
    
    func imagePicker() {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.wordings.libraryTitle = "새 게시물"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.showsPhotoFilters = false
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.pickImage = photo.image
                self.performSegue(withIdentifier: "GoFeedNewViewController", sender: nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

}


extension FeedViewController: BtnMoreDelegate{
    func btnMoreAction(index: Int) {
        print("여기보세요 \(index)")
        setBottomSheet(tableIndex: index)
    }
    
    func btnCommentsAction(index: Int) {
        print("댓글댓글")
        modifyIndex = index
        performSegue(withIdentifier: "GoFeedCommentsViewController", sender: nil)
    }
}

extension FeedViewController: FloatingPanelControllerDelegate{
    func setBottomSheet(tableIndex: Int) {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        
        //화면의 테두리? 화면 모양변경가능, 배경색이랑 코너각도 변경할 수 있음
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        fpc.surfaceView.appearance = appearance

        let bottomSheetViewController = self.storyboard?.instantiateViewController(identifier: "BottomSheetViewController") as! BottomSheetViewController
        bottomSheetViewController.btnDidTabdDelegate = self
        bottomSheetViewController.cellIndex = tableIndex
        
        fpc.contentMode = .fitToBounds
        fpc.layout = MyFloatingPanelLayout()
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        //밑에 세개가 위에 모달같이 생성하는 거!
        fpc.set(contentViewController: bottomSheetViewController)
        //이게 밑으로 내렸을때 모달이 없어지는 거!
        fpc.isRemovalInteractionEnabled = true
        
        self.present(fpc, animated: true, completion: nil)
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full, .half: return 0.7
        default: return 0.0
        }
    }
}


extension FeedViewController: BtnDidTabdDelegate{
    func btnModifyAction(index: Int) {
        print("수정클릭클릭 \(index)")
        print("\(feedsResult[index])")
        modifyIndex = index
        performSegue(withIdentifier: "GoFeedModifyViewController", sender: nil)
//        print("\(feedsResult[index].feedId!)")
    }
    func btnRemoveAction(index: Int) {
        print("삭제클릭클릭 \(index)")
        modifyIndex = index
        let bottomSheetViewController = self.storyboard?.instantiateViewController(identifier: "BottomSheetViewController") as! BottomSheetViewController
        bottomSheetViewController.dismiss(animated: true)
        
        let actionSheet = makeActionSheet(alertTitle: "", alertMessage: "이 게시물을 삭제하지 않으려면 게시물을 보관할 수 있습니다. \n보관한 게시물은 회원님만 볼 수 있습니다.")
        present(actionSheet, animated: true)
    }
}


extension FeedViewController {
    func makeActionSheet(alertTitle: String, alertMessage: String) -> UIAlertController {
        let actionSheet = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            print("클릭1")
        }
        let save = UIAlertAction(title: "보관", style: .default)
        actionSheet.addAction(delete)
        actionSheet.addAction(save)
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(cancle)
        
        return actionSheet
    }
    
    func deleteFeed() {
        APIFeedPatch().deleteFeed(accessToken: userToken.jwt!, feedId: modifyIndex)
    }
}
