//
//  JoinFinalViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/30.
//

import UIKit

class JoinFinalViewController: UIViewController {
    
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    var tfUserName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension JoinFinalViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnJoin:
            print("가입완료!")

        default:
            return
        }
    }
}
