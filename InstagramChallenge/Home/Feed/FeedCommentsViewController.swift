//
//  FeedCommentsViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class FeedCommentsViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()
    @IBOutlet weak var viewBgComment: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var tableViewComment: UITableView!
    
    var commentsResult = [CommentResponseResult]()
    var pageIndex = 0
    var feedIdx = 0
    var userID = ""
    var commentsText = ""
    var commentsfeedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedCommentsViewController()
        registerTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver()
        
        //댓글초기화
        pageIndex = 0
        commentsResult.removeAll()
        setCommentsInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserverRemove()
    }
    
    func setUIFeedCommentsViewController() {
        viewBgComment.layer.cornerRadius = viewBgComment.frame.height / 2
        viewBgComment.layer.borderWidth = 1
        viewBgComment.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func registerTableView() {
        let commentTableViewCellNib = UINib(nibName: "FeedCommentsTableViewCell", bundle: nil)
        self.tableViewComment.register(commentTableViewCellNib, forCellReuseIdentifier: "FeedCommentsTableViewCell")
        
        tableViewComment.dataSource = self
        tableViewComment.delegate = self
        
        tableViewComment.separatorStyle = .none
    }
    
    func setCommentsInfo() {
        APIFeedGet().getComments(accessToken: userToken.jwt!, feedId: feedIdx, pageIndex: 0, size: 10, completion: { result in
            switch result {
            case .success(let result):
                if self.pageIndex == 0 {
                    self.commentsResult = result

                } else {
                    self.commentsResult += result
                }
                print("???!?!?")
                self.tableViewComment.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    @IBAction func bgViewDidTab(_ sender: Any) {
        view.endEditing(true)
    }
}

extension FeedCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 10
            
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
            cell.labelText.text = "\(commentsResult[indexPath.row].loginID ?? "아이디없음")  \(commentsResult[indexPath.row].commentText ?? "")"
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func keyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.viewComment.frame.origin.y -= (keyboardHeight-20)
                
              }
          }
    }

    @objc func keyboardHide(notification: NSNotification) {
        if self.viewComment.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.viewComment.frame.origin.y += (keyboardHeight-20)
                }
            }
        }
    }
}
