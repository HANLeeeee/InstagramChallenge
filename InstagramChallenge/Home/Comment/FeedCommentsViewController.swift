//
//  FeedCommentsViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class FeedCommentsViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()
 
    @IBOutlet weak var viewCommentConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBgComment: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var tableViewComment: UITableView!
    @IBOutlet weak var tfComments: UITextField!
    @IBOutlet weak var btnCreateComments: UIButton!
    
    var commentsResult = [CommentResponseResult]()
    let refreshControl = UIRefreshControl()
    var pageIndex = 0
    var feedId = 0
    var userID = ""
    var commentsText = ""
    var commentsfeedDate = ""
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedCommentsViewController()
        registerTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver()
        
        tfComments.text = ""
        pageIndex = 0
        commentsResult.removeAll()
        setCommentsInfo(pageIdx: pageIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserverRemove()
    }
    
    //MARK: UI
    func setUIFeedCommentsViewController() {
        viewBgComment.layer.cornerRadius = viewBgComment.frame.height / 2
        viewBgComment.layer.borderWidth = 1
        viewBgComment.layer.borderColor = UIColor.systemGray3.cgColor
        
        btnCreateComments.isEnabled = false
    }
    
    //MARK: 테이블뷰셀 등록
    func registerTableView() {
        let commentTableViewCellNib = UINib(nibName: "FeedCommentsTableViewCell", bundle: nil)
        self.tableViewComment.register(commentTableViewCellNib, forCellReuseIdentifier: "FeedCommentsTableViewCell")
        
        tableViewComment.dataSource = self
        tableViewComment.delegate = self
        
        tableViewComment.separatorStyle = .none
        
        refreshControl.endRefreshing()
        tableViewComment.refreshControl = refreshControl
    }
    
    //MARK: 댓글정보가져오기
    func setCommentsInfo(pageIdx: Int) {
        APIFeedGet().getComments(accessToken: userToken.jwt!, feedId: feedId, pageIndex: pageIdx, size: 10, completion: { result in
            switch result {
            case .success(let commentsResult):
                if pageIdx == 0 {
                    self.commentsResult = commentsResult

                } else {
                    self.commentsResult += commentsResult
                }
                self.tableViewComment.reloadData()
                self.refreshControl.endRefreshing()
                
            case .failure(let error):
                print(error)
            }
        })
    }
}




//MARK: IBAction
extension FeedCommentsViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnCreateComments:
            createCommentsAction()
            
        default:
            return
        }
    }
    
    @IBAction func bgViewDidTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 200 {
            textField.deleteBackward()
        }
        if textField.text!.count > 0 {
            btnCreateComments.isEnabled = true
        }
    }
}





//MARK: 버튼액션
extension FeedCommentsViewController {
    func createCommentsAction() {
        APIFeedPost().createComment(accessToken: userToken.jwt!, feedId: self.feedId, commentText: tfComments.text!, completion: { result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    self.tfComments.text = ""
                    self.pageIndex = 0
                    self.setCommentsInfo(pageIdx: self.pageIndex)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}





//MARK: 테이블뷰 델리게이트
extension FeedCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            pageIndex = 0
            commentsResult.removeAll()
            setCommentsInfo(pageIdx: pageIndex)
        } else if self.tableViewComment.contentOffset.y > tableViewComment.contentSize.height-tableViewComment.bounds.size.height {
            pageIndex += 1
            setCommentsInfo(pageIdx: pageIndex)
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
            return commentsResult.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewComment.dequeueReusableCell(withIdentifier: "FeedCommentsTableViewCell", for: indexPath) as! FeedCommentsTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.labelCoComment.isHidden = true
            cell.btnHeart.isHidden = true
            
            cell.labelText.text = "\(userID)  \(commentsText)"
            cell.labelDate.text = dateSub(date: commentsfeedDate)
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            cell.labelCoComment.isHidden = false
            cell.btnHeart.isHidden = false
            
            cell.labelText.text = "\(commentsResult[indexPath.row].loginId ?? "")  \(commentsResult[indexPath.row].commentText ?? "")"
            cell.labelDate.text = dateSub(date: commentsResult[indexPath.row].createdAt!)

            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}





//MARK: 키보드옵저버
extension FeedCommentsViewController {
    func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWhillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func keyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWhillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            if self.viewCommentConstraint.constant == 0{
                self.viewCommentConstraint.constant += (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            if self.viewCommentConstraint.constant != 0{
                self.viewCommentConstraint.constant -= (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))

            }
        }
    }
}
