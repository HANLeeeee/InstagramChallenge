//
//  ViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/26.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon


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
        setUILoginViewController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: UI
    func setUILoginViewController() {
        btnLogin.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnLogin.layer.cornerRadius = 10
        btnLogin.isEnabled = false
    }
}




//MARK: IBAction
extension LoginViewController {
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
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 20 {
            textField.deleteBackward()
        }
        if textFieldID.text!.count > 0 && textFieldPW.text!.count > 0 {
            btnLogin.backgroundColor = UIColor.link
            btnLogin.isEnabled = true
        } else {
            btnLogin.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnLogin.isEnabled = false
        }
    }
}




//MARK: 버튼액션
extension LoginViewController{
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
        if isValidCheck(id: textFieldID.text!, pw: textFieldPW.text!) {
            checkUser()
        } else {
            presentLoginFail()
        }
    }
    
    func btnKakaoLoginAction() {
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginApp()
        } else {
            kakaoLoginWeb()
        }
    }
    
    func btnJoinAction() {
        performSegue(withIdentifier: "GoJoinViewController", sender: nil)
    }
}




//MARK: 자체 로그인 메소드
extension LoginViewController {
    func isValidCheck(id: String, pw: String) -> Bool {
        var idcheck = false
        var pwcheck = false

        if id.count > 3 && id.count < 21 {
            idcheck = true
        }
        if idcheck {
            if pw.count > 6 && pw.count < 21 {
                let str = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,20}"
                let predic = NSPredicate(format: "SELF MATCHES %@", str)
                pwcheck = predic.evaluate(with: pw)
            }
        }
        return idcheck && pwcheck
    }
    
    func checkUser() {
        if let userID = textFieldID.text,
           let userPW = textFieldPW.text {
            APIUserPost().signIn(loginId: userID, password: userPW, completion: { result in
                switch result {
                case .success(let result):
                    if result.isSuccess {
                        self.presentFeedVC()
                    } else {
                        self.presentLoginFail()
                    }
                case .failure(let error):
                    print(error)
                }
            })
            return
        }
    }
}




//MARK: 카카오 로그인 메소드
extension LoginViewController {
    func kakaoLoginApp() {
        UserApi.shared.loginWithKakaoTalk {(authToken, error) in
            if let error = error {
                print(error)
                self.present(self.alert, animated: true)
            } else {
                if (authToken?.accessToken) != nil {
                    print("어세스토큰발생 \(authToken!.accessToken)")
                    APIKakaoPost().kakaoSignIn(accessToken: authToken!.accessToken, completion: { result in
                        switch result {
                        case .success(let result):
                            if result.isSuccess {
                                self.presentFeedVC()
                            } else {
                                self.kakaologinfailureAPI(result.code)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }
        }
    }

    func kakaoLoginWeb() {
        UserApi.shared.loginWithKakaoAccount {(authToken, error) in
            if let error = error {
                print(error)
                self.present(self.alert, animated: true)
            } else {
                print("성공")
                if (authToken?.accessToken) != nil {
                    print("어세스토큰발생 \(authToken!.accessToken)")
                    APIKakaoPost().kakaoSignIn(accessToken: authToken!.accessToken, completion: { result in
                        switch result {
                        case .success(let result):
                            if result.isSuccess {
                                self.presentFeedVC()
                            } else {
                                self.kakaologinfailureAPI(result.code)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }
        }
    }

    func kakaologinfailureAPI(_ code: Int) {
        switch code {
        case 2100:
            //회원가입이 안된상태
            performSegue(withIdentifier: "GoJoinPhoneViewController", sender: nil)
        default:
            self.present(self.alert, animated: true)
        }
    }
}




//MARK: 커스텀메소드
extension LoginViewController {
    func presentFeedVC() {
        let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as! FeedTabBarViewController

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(FeedTabBarViewController, animated: true)
    }
    
    func presentLoginFail() {
        let alert = makeAlertLoginFail(alertTitle: "계정을 찾을 수 없음", alertMessage: "\(textFieldID.text!)에 연결된 계정을 찾을 수 없습니다. 다른 전화번호나 이메일 주소를 사용해보세요. Instagram 계정이 없으면 가입할 수 있습니다.", btnAgreeTitle: "가입하기", btnCancleTitle: "다시시도")
        present(alert, animated: false)
    }
    
    func makeAlertLoginFail(alertTitle: String, alertMessage: String, btnAgreeTitle: String, btnCancleTitle: String) -> UIAlertController {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let agree = UIAlertAction(title: btnAgreeTitle, style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "GoJoinViewController", sender: nil)
            
        })
        let cancle = UIAlertAction(title: btnCancleTitle, style: .default)
        alert.addAction(agree)
        alert.addAction(cancle)
        
        return alert
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
