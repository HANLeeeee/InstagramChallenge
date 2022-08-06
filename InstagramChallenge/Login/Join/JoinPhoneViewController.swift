//
//  JoinPhoneViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class JoinPhoneViewController: UIViewController {
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var currentIndex: Int = 0
    var pageViewController: PageViewController!
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoPageViewController" {
            let pageVC = segue.destination as! PageViewController
            pageViewController = pageVC
            pageViewController.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }
}




//MARK: IBAction
extension JoinPhoneViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnPhone:
            pageViewController.setViewControllersIndex(index: 0)
            btnPhone.titleLabel?.textColor = UIColor.black
            btnEmail.titleLabel?.textColor = UIColor.lightGray
            
        case btnEmail:
            pageViewController.setViewControllersIndex(index: 1)
            btnPhone.titleLabel?.textColor = UIColor.lightGray
            btnEmail.titleLabel?.textColor = UIColor.black
            
        case btnLogin:
            self.navigationController?.popViewController(animated: true)
            
        default:
            return
        }
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
}
