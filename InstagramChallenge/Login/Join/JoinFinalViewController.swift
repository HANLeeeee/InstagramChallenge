//
//  JoinFinalViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/30.
//

import UIKit

class JoinFinalViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var joinData = UserPostRequest()

    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinFinalViewController()
    }
    
    //MARK: UI
    func setUIJoinFinalViewController() {
        btnJoin.layer.cornerRadius = 10
        labelTitle.text = "\(joinData.loginId!)\n님으로 가입하시겠어요?"
    }
    
}



//MARK: IBAction
extension JoinFinalViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnJoin:
            createUser()
            
        default:
            return
        }
    }
}



//MARK: 회원가입
extension JoinFinalViewController {
    func createUser() {
        Loading.showLoading()
        DispatchQueue.main.async {
            if let userName = self.joinData.realName,
               let userPW = self.joinData.password,
               let userID = self.joinData.loginId,
               let userBirth = self.joinData.birthDate,
               let userPN = self.joinData.phoneNumber {
                APIUserPost().signUp(realName: userName, password: userPW, loginId: userID, birthDate: userBirth, phoneNumber: userPN, completion: { result in
                    Loading.hideLoading()
                    switch result {
                    case .success(let result):
                        if result.isSuccess {
                            UserDefaultsData.shared.setToken(userID: userID, jwt: result.result!.jwt!)
                            self.presentFeedVC()
                            
                        } else {
                            let alert = makeAlert("알림", "회원가입에 실패하였습니다.", true, "확인")
                            self.present(alert, animated: false)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    
                    case .failure(let error):
                        print(error)
                    }
                })
                return
            }
        }
    }
}



//MARK: 커스텀메소드
extension JoinFinalViewController {
    func presentFeedVC() {
        let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as! FeedTabBarViewController

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(FeedTabBarViewController, animated: true)
    }
}
