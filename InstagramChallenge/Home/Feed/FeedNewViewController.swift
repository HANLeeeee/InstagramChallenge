//
//  FeedNewViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import UIKit
import FirebaseStorage
import FirebaseCore

class FeedNewViewController: UIViewController {
    let userInfo = UserDefaultsData.shared.getToken()
    @IBOutlet weak var barbtnNext: UIBarButtonItem!
    @IBOutlet weak var btnSeoul: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewPickImage: UIImageView!
    @IBOutlet weak var hiddenView: UIView!
    
    var pickImage = UIImage()
    var uploadURL: String = ""
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIFeedNewViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        keyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserverRemove()
    }
    
    //MARK: UI
    func setUIFeedNewViewController() {
        btnSeoul.layer.cornerRadius = 10
        imageViewPickImage.image = pickImage
    
    }
}




//MARK: IBAction
extension FeedNewViewController {
    @IBAction func barbtnAction(_ barbtn: UIBarButtonItem) {
        switch barbtn {
        case barbtnNext:
            print("다음")
            switch barbtnNext.title{
            case "공유":
                if textView.text != "문구 입력...." {
                    uploadToFirebase()
                } else {
                    let alert = makeAlert("알림", "게시글을 입력해야합니다", true, "확인")
                    self.present(alert, animated: true)
                }
                
            case "확인":
                view.endEditing(true)
                
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func tabBackView(_ sender: Any) {
        view.endEditing(true)
    }
}





//MARK: 피드 생성
extension FeedNewViewController {
    func uploadToFirebase() {
        let filepath = Storage.storage().reference(withPath: "danbi/\(userInfo.loginId!)/danbi_\(getCurrentMilly()).jpg")
        guard let imageData = imageViewPickImage.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        filepath.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }

            filepath.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                print("사진 url : ", url?.absoluteString ?? "")
                self.uploadURL = url?.absoluteString ?? ""
                self.uploadToServer()
            }
        }
    }
    
    func uploadToServer() {
        APIFeedPost().createFeed(accessToken: userInfo.jwt!, feedText: textView.text ?? "", contentsUrls: [self.uploadURL], completion: { result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getCurrentMilly() -> Int64 {
        var currentime: Int64 {
            Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
        }
        return currentime
    }
}




//MARK: 키보드옵저버
extension FeedNewViewController {
    func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func keyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardShow(notification: NSNotification) {
        self.navigationController?.navigationBar.topItem?.title = "문구"
        barbtnNext.title = "확인"
        hiddenView.isHidden = false
        if textView.text == "문구 입력...." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    @objc func keyboardHide(notification: NSNotification) {
        self.navigationController?.navigationBar.topItem?.title = "새 게시물"
        barbtnNext.title = "공유"
        hiddenView.isHidden = true
        if textView.text?.count == 0 {
            textView.text = "문구 입력...."
            textView.textColor = .gray
        }
    }
}
