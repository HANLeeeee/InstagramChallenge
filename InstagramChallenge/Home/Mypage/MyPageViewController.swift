//
//  MyPageViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import UIKit
import YPImagePicker

class MypageViewController: UIViewController {
    let userToken = UserDefaultsData.shared.getToken()

    @IBOutlet weak var btnNewPost: UIButton!
    @IBOutlet weak var labelLoginId: UILabel!
    @IBOutlet weak var labelRealName: UILabel!
    @IBOutlet weak var labelFeedCount: UILabel!
    @IBOutlet weak var labelFollowerCount: UILabel!
    @IBOutlet weak var labelFollowingCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIMypageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        getUserInfo()
    }
    
    func setUIMypageViewController() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
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

extension MypageViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNewPost:
            print("")
            imagePicker()
        default:
            return
        }
    }
    
    func imagePicker() {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.wordings.libraryTitle = "새 게시물"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.showsPhotoFilters = false
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
                guard let FeedNewViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedNewViewController") as? FeedNewViewController else {
                    return
                }
                FeedNewViewController.pickImage = photo.image
                self.navigationController?.pushViewController(FeedNewViewController, animated: true)
//                self.performSegue(withIdentifier: "GoFeedNewViewController", sender: nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}
