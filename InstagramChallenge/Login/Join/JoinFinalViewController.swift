//
//  JoinFinalViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/30.
//

import UIKit

class JoinFinalViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension JoinFinalViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)

        default:
            return
        }
    }
}
