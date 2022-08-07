//
//  FeedModifyViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class FeedModifyViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()
    
    @IBOutlet weak var btnBack:UIBarButtonItem!
    @IBOutlet weak var btnOK: UIBarButtonItem!
    @IBOutlet weak var labelUserID: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var originY: CGFloat = 0
    var feedID = 0
    var userID = ""
    var modifyImageURL = ""
    var modifyText = ""
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedModifyViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserverRemove()
    }
    
    //MARK: UI
    func setUIFeedModifyViewController() {
        textView.delegate = self

        labelUserID.text = userID
        textView.text = modifyText
        textView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        guard let imageUrl = URL(string: modifyImageURL) else {
            imageView.image = UIImage()
            return }
        imageView.kf.setImage(with: imageUrl)
    }
}



//MARK: IBAction
extension FeedModifyViewController {
    @IBAction func btnAction(_ barbtn: UIBarButtonItem) {
        switch barbtn {
        case btnBack:
            self.navigationController?.popViewController(animated: true)
            
        case btnOK:
            setModifyFeed()
            
        default:
            return
        }
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
}




//MARK: 버튼액션
extension FeedModifyViewController {
    func setModifyFeed() {
        Loading.showLoading()
        DispatchQueue.main.async {
            APIFeedPatch().modifyFeed(accessToken: self.userToken.jwt!, feedId: self.feedID, feedText: self.textView.text, completion: { result in
                Loading.hideLoading()
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    print(error)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}




//MARK: 텍스트뷰 델리게이트
extension FeedModifyViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimated  = textView.sizeThatFits(size)
        textViewHeightConstraint.constant = estimated.height+15
        scrollView.scrollToBottom()
    }
}

extension UIScrollView {
    func scrollToBottom() {
        let offset = CGPoint(
            x: 0,
            y: contentSize.height - bounds.height
        )
        setContentOffset(offset, animated: false)
    }
}



//MARK: 키보드옵저버
extension FeedModifyViewController {
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
            if self.bottomConstraint.constant == 0 {
                self.bottomConstraint.constant += (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))
                self.scrollView.scrollToBottom()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            if self.bottomConstraint.constant != 0 {
                self.bottomConstraint.constant -= (keyboardHeight-(window?.safeAreaInsets.bottom ?? 0))
                self.scrollView.scrollToBottom()
            }
        }
    }
}



