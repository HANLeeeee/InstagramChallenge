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
//        keyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        keyboardObserverRemove()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUILoginViewController() {
        btnLogin.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnLogin.layer.cornerRadius = 10
        btnLogin.isEnabled = false
    }
    
    @IBAction func tfEditingChanged(_ textfield: UITextField) {
        
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
        if textFieldID.text!.count > 0 && textFieldPW.text!.count > 0 {
            btnLogin.backgroundColor = UIColor.link
            btnLogin.isEnabled = true
        } else {
            btnLogin.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnLogin.isEnabled = false
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
        if isValidCheck(id: textFieldID.text!, pw: textFieldPW.text!) {
            checkUser()
        } else {
            presentFailurePopup()
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
        switch code {
        default:
            presentFailurePopup()
        }

    }
    
    func presentFeedVC() {
        let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as! FeedTabBarViewController

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(FeedTabBarViewController, animated: true)

        FeedTabBarViewController.modalPresentationStyle = .fullScreen
        self.present(FeedTabBarViewController, animated: true, completion: nil)
    }
    
    
    func presentFailurePopup() {
        let alert = makeAlertSelcet(alertTitle: "계정을 찾을 수 없음", alertMessage: "\(textFieldID.text!)에 연결된 계정을 찾을 수 없습니다. 다른 전화번호나 이메일 주소를 사용해보세요. Instagram 계정이 없으면 가입할 수 있습니다.", btnAgreeTitle: "가입하기", btnCancleTitle: "다시시도")
        present(alert, animated: false)
    }
    
    func makeAlertSelcet(alertTitle: String, alertMessage: String, btnAgreeTitle: String, btnCancleTitle: String) -> UIAlertController {
        
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


//MARK: 카카오 로그인
extension LoginViewController {
    func kakaoLoginApp() {
        UserApi.shared.loginWithKakaoTalk {(authToken, error) in
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
                                self.kakaologinsuccessAPI()
                            } else {
                                self.kakaologinfailureAPI(result.code)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
                print("화면이동")
                //서버에서 있는 지 확인
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
                                self.kakaologinsuccessAPI()
                            } else {
                                self.kakaologinfailureAPI(result.code)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
//                        self.presentFeedVC()
                print("화면이동")
                //서버에서 있는 지 확인
                    
                
            }
        }
    }

    func kakaologinsuccessAPI() {
//        presentFeedVC()
        
        let alert = makeAlertSelcet(alertTitle: "카칸오", alertMessage: "로그인.", btnAgreeTitle: "?", btnCancleTitle: "!")
        present(alert, animated: false)
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
