//
//  JoinUserNameViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/30.
//

import UIKit

class JoinUserNameViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var labelHidden: UILabel!
    
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    var constraint: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraint = btnTopConstraint.constant
    }
    
    @IBAction func tfEditingChangedAction(_ sender: Any) {
        labelHidden.isHidden = false
        if btnTopConstraint.constant == constraint {
            btnTopConstraint.constant += labelHidden.frame.height+10
        }
    }
}


//MARK: 액션이벤트
extension JoinUserNameViewController {
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        default:
            return
        }
    }
}
