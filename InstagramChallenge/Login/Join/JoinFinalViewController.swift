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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIJoinFinalViewController()
    }
    
    func setUIJoinFinalViewController() {
        labelTitle.text = "\(joinData.loginId!)\n님으로 가입하시겠어요?"
    }
    
}

extension JoinFinalViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnJoin:
            print("가입완료!")
            createUser()

        default:
            return
        }
    }
    
    func createUser() {
        if let userName = joinData.realName,
           let userPW = joinData.password,
           let userID = joinData.loginId,
           let userBirth = joinData.birthDate,
           let userPN = joinData.phoneNumber {
            APIUserPost().signUp(realName: userName, password: userPW, loginId: userID, birthDate: userBirth, phoneNumber: userPN, joinFinalVC: self)

            return
        }
    }
}


extension JoinFinalViewController {
    func joinsuccessAPI(_ result: UserResponseResult) {
        changeRootView()
    }
    
    func joinfailureAPI(_ code: Int) {
        
        let alert = makeAlert("알림", "회원가입에 실패하였습니다.", true, "확인")
        present(alert, animated: false)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func changeRootView() {
        presentFeedVC()
    }
    
    func presentFeedVC() {
        let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as! FeedTabBarViewController

        FeedTabBarViewController.modalPresentationStyle = .fullScreen
        self.present(FeedTabBarViewController, animated: true, completion: nil)
    }
}
