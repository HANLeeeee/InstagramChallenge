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

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnNewPost: UIButton!
    @IBOutlet weak var labelLoginId: UILabel!
    @IBOutlet weak var labelRealName: UILabel!
    @IBOutlet weak var labelFeedCount: UILabel!
    @IBOutlet weak var labelFollowerCount: UILabel!
    @IBOutlet weak var labelFollowingCount: UILabel!
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIMypageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getUserInfo()
    }
    
    //MARK: UI
    func setUIMypageViewController() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    //MARK: 마이페이지정보가져오기
    func getUserInfo() {
        APIUserGet().searchMyPage(accessToken: userToken.jwt!, loginId: userToken.loginId!, completion: { result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    self.labelLoginId.text = result.result!.loginId ?? ""
                    self.labelRealName.text = result.result!.realName ?? ""
                    self.labelFeedCount.text = String(result.result!.feedCount ?? 0)
                    self.labelFollowerCount.text = String(result.result!.followerCount ?? 0)
                    self.labelFollowingCount.text = String(result.result!.followingCount ?? 0)
                    
                } else {
                    self.presentLoginVC()
                }
            
            case .failure(let error):
                print(error)
            }
        })
    }
}



//MARK: IBAction
extension MypageViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNewPost:
            imagePicker()
        
        //프로필편집을 누르면 로그아웃 (임의 설정)
        case btnLogout:
            UserDefaultsData.shared.removeAll()
            presentLoginVC()
            
        default:
            return
        }
    }
}


//MARK: 버튼액션
extension MypageViewController {
    //새 게시물등록을을 위한 갤러리 열기 -YPImagePicker라이브러리
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
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func presentLoginVC() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let LoginNavigationViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! LoginNavigationViewController

        LoginNavigationViewController.modalPresentationStyle = .fullScreen
        self.present(LoginNavigationViewController, animated: true, completion: nil)
    }
}
