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

    @IBOutlet weak var btnNewPost: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var feedTableView: UITableView!

    var pickImage = UIImage()
    var pageIndex = 0
    var modifyIndex = 0
    var feedsResult = [FeedResponseResult]()
    let refreshControl = UIRefreshControl()

    //MARK: 생명주기
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: UI
    func setUIFeedViewController() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    //MARK: 피드정보가져오기
    func getFeedInfo(pageIdx: Int) {
        APIFeedGet().getFeeds(accessToken: userToken.jwt!, pageIndex: pageIdx, size: 10) { result in
            switch result {
            case .success(let feedsResult):
                if self.pageIndex == 0 {
                    self.feedsResult = feedsResult
                } else {
                    self.feedsResult += feedsResult
                }
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                }
                
                self.refreshControl.endRefreshing()

            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: 테이블뷰셀 등록
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
    
    //MARK: 데이터전달
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
            feedCommentsVC.feedId = feedsResult[modifyIndex].feedId!
            feedCommentsVC.userID = feedsResult[modifyIndex].feedLoginId!
            feedCommentsVC.commentsText = feedsResult[modifyIndex].feedText ?? ""
            feedCommentsVC.commentsfeedDate = feedsResult[modifyIndex].feedCreatedAt!
            
        default:
            return
        }
    }
}




//MARK: IBAction
extension FeedViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNewPost:
            imagePicker()
            
        case btnChat:
            performSegue(withIdentifier: "GoFeedChatViewController", sender: nil)
            
        default:
            return
        }
    }
}



//MARK: 버튼액션
extension FeedViewController {
    //새 게시물등록을 위한 갤러리 열기 -YPImagePicker라이브러리
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




//MARK: 피드의 더보기
extension FeedViewController: BtnMoreDelegate{
    func btnMoreAction(index: Int) {
        setBottomSheet(tableIndex: index)
    }
//MARK: 피드의 댓글보기
    func btnCommentsAction(index: Int) {
        modifyIndex = index
        performSegue(withIdentifier: "GoFeedCommentsViewController", sender: nil)
    }
}




//피드의 더보기 바텀시트
extension FeedViewController: BtnDidTabdDelegate{
//MARK: 피드 수정
    func btnModifyAction(index: Int) {
        modifyIndex = index
        performSegue(withIdentifier: "GoFeedModifyViewController", sender: nil)
    }
//MARK: 피드 삭제
    func btnRemoveAction(index: Int) {
        modifyIndex = index
        let bottomSheetViewController = self.storyboard?.instantiateViewController(identifier: "BottomSheetViewController") as! BottomSheetViewController
        bottomSheetViewController.dismiss(animated: true)
        
        let actionSheet = makeActionSheet(alertTitle: "", alertMessage: "이 게시물을 삭제하지 않으려면 게시물을 보관할 수 있습니다. \n보관한 게시물은 회원님만 볼 수 있습니다.")
        present(actionSheet, animated: true)
    }
    
    func makeActionSheet(alertTitle: String, alertMessage: String) -> UIAlertController {
        let actionSheet = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.deleteFeed()
        }
        let save = UIAlertAction(title: "보관", style: .default)
        actionSheet.addAction(delete)
        actionSheet.addAction(save)
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(cancle)
        
        return actionSheet
    }
    
    func deleteFeed() {
        APIFeedPatch().deleteFeed(accessToken: userToken.jwt!, feedId: feedsResult[modifyIndex].feedId!, completion: { res in
            switch res {
            case .success(let deleteRes):
                if deleteRes.isSuccess {
                    self.pageIndex = 0
                    self.getFeedInfo(pageIdx: self.pageIndex)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}




//MARK: 테이블뷰 데이터
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            pageIndex = 0
            feedsResult.removeAll()
            getFeedInfo(pageIdx: pageIndex)
        } else if self.feedTableView.contentOffset.y > feedTableView.contentSize.height-feedTableView.bounds.size.height {
            pageIndex += 1
            getFeedInfo(pageIdx: pageIndex)
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
    
    //셀정보
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




//MARK: 바텀시트 -FloatingPanel라이브러리
extension FeedViewController: FloatingPanelControllerDelegate {
    func setBottomSheet(tableIndex: Int) {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        fpc.surfaceView.appearance = appearance

        let bottomSheetViewController = self.storyboard?.instantiateViewController(identifier: "BottomSheetViewController") as! BottomSheetViewController
        bottomSheetViewController.btnDidTabdDelegate = self
        bottomSheetViewController.cellIndex = tableIndex
        
        fpc.contentMode = .fitToBounds
        fpc.layout = MyFloatingPanelLayout()
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        fpc.set(contentViewController: bottomSheetViewController)
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
