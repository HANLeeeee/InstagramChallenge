//
//  ViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/26.
//

import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    @IBOutlet weak var constraint: NSLayoutConstraint!

    @IBOutlet weak var textFieldID: UITextField!
    @IBOutlet weak var textFieldPW: UITextField!
    
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    
    let alert = makeAlert("알림", "로그인에 실패하였습니다.", true, "확인")
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        keyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        keyboardObserverRemove()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

//MARK: 액션이벤트
extension LoginViewController {
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 20 {
            textField.deleteBackward()
        }
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnEye:
            btnEyeTouchUp(btn)
            
        case btnLogin:
            btnLoginAction()
            
        case btnKakao:
            btnKakaoLoginAction()
            
        case btnJoin:
            btnJoinAction()
            
        default:
            return
        }
    }
    
    func btnEyeTouchUp(_ btn: UIButton) {
        if btn.isSelected {
            btn.isSelected = false
            btn.setBackgroundImage(UIImage(named: "icon_eye"), for: .selected)
            textFieldPW.isSecureTextEntry = true
            
        } else {
            btn.isSelected = true
            btn.setBackgroundImage(UIImage(named: "icon_eyeSlash"), for: .normal)
            textFieldPW.isSecureTextEntry = false
            
        }
    }
    
    func btnLoginAction() {
        //1. 유효성검사하기
            //2 성공시 존재하는 지 서버에서 확인
            checkUser()
            
            //2 존재하지않거나 아이디비번이 틀리면 팝업노출
        //1. 유효성실패시 팝업노출
        
        


    }
    
    func btnKakaoLoginAction() {
        print("??")
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginApp()
        } else {
            kakaoLoginWeb()
        }
    }
    
    func btnJoinAction() {
//        performSegue(withIdentifier: "GoJoinViewController", sender: nil)
        
    }
}

//MARK: 일반로그인
extension LoginViewController {
    
    func checkUser() {
        if let userID = textFieldID.text,
           let userPW = textFieldPW.text {
            APIUserPost().signIn(loginId: userID, password: userPW, loginVC: self)

            return
        }
    }
    
    func loginsuccessAPI(_ result: UserResponseResult) {
        presentFeedVC()
    }
    
    func loginfailureAPI(_ code: Int) {

    }
    
    func presentFeedVC() {
        let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as! FeedTabBarViewController

        FeedTabBarViewController.modalPresentationStyle = .fullScreen
        self.present(FeedTabBarViewController, animated: true, completion: nil)
    }
}

//MARK: 키보드옵저버
//extension LoginViewController {
//    func keyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func keyboardObserverRemove() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardShow(notification: NSNotification) {
//        if self.constraint.constant != 0 {
//            self.constraint.constant -= 50
//        }
//    }
//
//    @objc func keyboardHide(notification: NSNotification) {
//        self.constraint.constant += 50
//    }
//}

//MARK: 카카오톡로그인
extension LoginViewController {
    func kakaoLoginApp() {
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
                self.present(self.alert, animated: true)
            } else {
                print("성공")
                
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                        self.present(self.alert, animated: true)
                    } else {
                        //아이디체크해서 있으면 이동 없으면 가입으로 이동
                        print("화면이동")
                    }
                }
            }
        }
    }
    
    func kakaoLoginWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
                self.present(self.alert, animated: true)
            } else {
                print("성공")
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                        self.present(self.alert, animated: true)
                    } else {
                        //아이디체크해서 있으면 이동 없으면 가입으로 이동
                        print("화면이동")
                    }
                }
            }
        }
    }
    
}
