//
//  FeedViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/31.
//

import UIKit
import Kingfisher
import YPImagePicker

class FeedViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()
    var feedsResult = [FeedResponseResult]()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnNewPost: UIButton!
    
    var pickImage = UIImage()
    var pageIndex = 0
    var size = 10

    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedViewController()
        getFeedInfo(pageIdx: pageIndex)
        registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        if segue.identifier == "GoFeedNewViewController" {
            let feedNewVC = segue.destination as! FeedNewViewController
            feedNewVC.pickImage = self.pickImage
        }
    }
}


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

        cell.labelfeedLoginId.text = feedsResult[indexPath.row].feedLoginId
        cell.labelfeedIdplusText.text = "\(feedsResult[indexPath.row].feedLoginId)  \(feedsResult[indexPath.row].feedText)"
        cell.labelfeedCreatedAt.text = feedsResult[indexPath.row].feedCreatedAt
        cell.labelfeedCommentCount.text = "댓글 \(feedsResult[indexPath.row].feedCommentCount)개 모두보기"
    
            
        guard let imageUrl = URL(string: self.feedsResult[indexPath.row].contentsList[0].contentsUrl) else {
            cell.imageViewFeed.image = UIImage()
            return }
        cell.imageViewFeed.kf.setImage(with: imageUrl)
    }
}


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
