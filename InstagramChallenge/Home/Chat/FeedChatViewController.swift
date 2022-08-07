//
//  FeedChatViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class FeedChatViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textViewMsg: UITextView!
    @IBOutlet weak var viewBgChatMsg: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var imageViewEmoticon: UIImageView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    var chatResult = [ChatResponseResult]()
    let refreshControl = UIRefreshControl()
    var pageIndex = 0
    var size = 10
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedChatViewController()
        registerTableView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        keyboardObserver()
        
        pageIndex = 0
        chatResult.removeAll()
        getChatInfo(pageIdx: pageIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserverRemove()
    }
    
    //MARK: UI
    func setUIFeedChatViewController() {
        textViewMsg.delegate = self
        
        viewBgChatMsg.layer.cornerRadius = viewBgChatMsg.frame.height / 2
        viewBgChatMsg.layer.borderWidth = 1
        viewBgChatMsg.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    //MARK: 테이블뷰셀 등록
    func registerTableView() {
        let youtableViewCellNib = UINib(nibName: "YouChatTableViewCell", bundle: nil)
        self.chatTableView.register(youtableViewCellNib, forCellReuseIdentifier: "YouChatTableViewCell")
        
        let metableViewCellNib = UINib(nibName: "MeChatTableViewCell", bundle: nil)
        self.chatTableView.register(metableViewCellNib, forCellReuseIdentifier: "MeChatTableViewCell")
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        chatTableView.separatorStyle = .none
        
        refreshControl.endRefreshing()
        chatTableView.refreshControl = refreshControl
    }
    
    //MARK: 채팅정보가져오기
    func getChatInfo(pageIdx: Int) {
        APIChatGet().searchChat(accessToken: userToken.jwt!, pageIndex: pageIdx, size: 20, completion: { result in
            switch result {
            case .success(let chatresult):
                if self.pageIndex == 0 {
                    self.chatResult = chatresult.reversed()
                    self.scrollToBottom()
                    
                } else {
                    if chatresult.count != 0 {
                        self.chatResult.insert(contentsOf: chatresult.reversed(), at: 0)
                        self.chatTableView.scrollNotTop()
                    }
                }
                self.refreshControl.endRefreshing()

            case .failure(let error):
                print(error)
            }
            
        })
    }
}



//MARK: IBAction
extension FeedChatViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnSend:
            if textViewMsg.text.count != 0 {
                createMsgAction()
            }
            
        default:
            return
        }
    }
    
    @IBAction func viewbgTabAction(_ sender: Any) {
        view.endEditing(true)
    }
}



//MARK: 버튼액션
extension FeedChatViewController {
    func createMsgAction() {
        APIChatPost().createChat(accessToken: userToken.jwt!, content: textViewMsg.text, completion: { result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공")
                    self.textViewMsg.text = ""
                    self.pageIndex = 0
                    self.getChatInfo(pageIdx: self.pageIndex)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}



//MARK: 커스텀메소드
extension FeedChatViewController {
    func scrollToBottom(){
        DispatchQueue.main.async {
            self.chatTableView.reloadData()

            if self.chatResult.count > 0 {
               let ip = IndexPath(row: self.chatResult.count-1, section: 0)
               self.chatTableView.scrollToRow(at: ip, at: .bottom, animated: false)
            }
        }
    }
}



//MARK: 텍스트뷰 델리게이트
extension FeedChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textViewMsg.text?.count ?? 0 > 0 {
            imageViewEmoticon.isHidden = true
            btnSend.isHidden = false
        }

        if textView.numberOfLine() == 1 {
            heightConstraint.constant = 50
        } else if textView.numberOfLine() < 6 {
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimated  = textView.sizeThatFits(size)
            heightConstraint.constant = estimated.height+15
        }
    }
}

extension UITextView {
    func numberOfLine() -> Int {
        
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}



//MARK: 태이블뷰 델리게이트
extension FeedChatViewController : UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            pageIndex += 1
            getChatInfo(pageIdx: pageIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if userToken.loginId == chatResult[indexPath.row].loginId {
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "MeChatTableViewCell", for: indexPath) as! MeChatTableViewCell
            cell.labelMeChat.text = chatResult[indexPath.row].content
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "YouChatTableViewCell", for: indexPath) as! YouChatTableViewCell
            
            setYouCellValue(cell: cell, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setYouCellValue(cell: YouChatTableViewCell, indexPath: IndexPath) {
        let cellIndex = indexPath.row
        cell.labelYouChat.text = chatResult[cellIndex].content
        
        DispatchQueue.main.async {
            if self.chatResult[indexPath.row].loginId == "gridgeAdmin" {
                cell.imageViewProfile.image = UIImage(named: "icon_heart")
            } else {
                cell.imageViewProfile.image = UIImage(systemName: "person.crop.circle.fill")
            }
        }
        
        if cellIndex > 1 {
            if chatResult[cellIndex].loginId == chatResult[cellIndex-1].loginId {
                cell.imageViewProfile.isHidden = true
            }
        }
    }
}


extension UITableView {
    func scrollNotTop() {
        setContentOffset(contentOffset, animated: false)
        
        let beforeSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterSize = contentSize
        
        let offset = CGPoint(
            x: contentOffset.x + (afterSize.width-beforeSize.width),
            y: contentOffset.y + (afterSize.height-beforeSize.height)
        )
        
        setContentOffset(offset, animated: false)
    }
}




//MARK: 키보드옵저버
extension FeedChatViewController {
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
            if self.viewConstraint.constant == 0{
                self.scrollToBottom()
                self.viewConstraint.constant += (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            if self.viewConstraint.constant != 0{
                self.scrollToBottom()
                self.viewConstraint.constant -= (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))

            }
        }
    }
}





