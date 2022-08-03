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
        print(joinData)
        if let userName = joinData.realName,
           let userPW = joinData.password,
           let userID = joinData.loginId,
           let userBirth = joinData.birthDate,
           let userPN = joinData.phoneNumber {
            APIUserPost().signUp(realName: userName, password: userPW, loginId: userID, birthDate: userBirth, phoneNumber: userPN)

            return
        }
    }
}


extension JoinFinalViewController {
    func joinsuccessAPI(_ result: UserResponseResult) {
        UserDefaultsData.shared.setUserID(userID: joinData.loginId!)
        UserDefaultsData.shared.setJWT(jwt: result.jwt!)
    }
    
    func joinfailureAPI(_ code: Int) {
//        switch code {
//        case 2230:
//            self.statusMessage = "사용자 이름 \(tfUserID.text!)을(를) 사용할 수 없습니다."
//            visibleLoginStatusMessgae(true)
//        default:
//            self.statusMessage = "다른 아이디를 사용해주세요."
//            visibleLoginStatusMessgae(true)
//        }
    }
}
