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
    @IBOutlet weak var viewBack: UIView!
    
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
        originY = viewBack.frame.origin.y

        labelUserID.text = userID
        textView.text = modifyText
        
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
        APIFeedPatch().modifyFeed(accessToken: userToken.jwt!, feedId: feedID, feedText: textView.text, completion: { result in
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




//MARK: 키보드옵저버
extension FeedModifyViewController {
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
                self.viewBack.frame.origin.y -= keyboardHeight
                
              }
          }
    }

    @objc func keyboardHide(notification: NSNotification) {
        if self.originY != self.viewBack.frame.origin.y {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.viewBack.frame.origin.y += keyboardHeight
                }
            }
        }
    }
}
