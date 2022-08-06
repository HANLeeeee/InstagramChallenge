//
//  JoinViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class JoinViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnKakaoLogin: UIButton!
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: UI
    func setUIJoinViewController() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

}




//MARK: IBAction
extension JoinViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popViewController(animated: true)
            
            //!!!!!!카카오로그인
        default:
            return
        }
    }
}

