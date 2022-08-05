//
//  MyPageViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import UIKit

class MypageViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()

    @IBOutlet weak var labelLoginId: UILabel!
    @IBOutlet weak var labelRealName: UILabel!
    @IBOutlet weak var labelFeedCount: UILabel!
    @IBOutlet weak var labelFollowerCount: UILabel!
    @IBOutlet weak var labelFollowingCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
    }
    
    func getUserInfo() {
        APIUserGet().searchMyPage(accessToken: userToken.jwt!, loginId: userToken.loginId!, mypageVC: self)
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        UserDefaultsData.shared.removeAll()
        presentLoginVC()
    }
    
    func presentLoginVC() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let LoginNavigationViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! LoginNavigationViewController

        LoginNavigationViewController.modalPresentationStyle = .fullScreen
        self.present(LoginNavigationViewController, animated: true, completion: nil)
    }
    
    
}

extension MypageViewController {
    
    func searchMyPagesuccessAPI(_ result: UserResponseResult) {
        print(result)
        labelLoginId.text = result.loginId ?? ""
        labelRealName.text = result.realName ?? ""
        labelFeedCount.text = String(result.feedCount ?? 0)
        labelFollowerCount.text = String(result.followerCount ?? 0)
        labelFollowingCount.text = String(result.followingCount ?? 0)
        
    }
    
}
