//
//  JoinUserIDViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/30.
//

import UIKit

class JoinUserIDViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfUserID: UITextField!
    @IBOutlet weak var labelHidden: UILabel!
    
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    var constraint: CGFloat = 0
    
    var joinData = UserPostRequest()
    var statusMessage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinUserIDViewController()
    }
}


extension JoinUserIDViewController {
    func setUIJoinUserIDViewController() {
        constraint = btnTopConstraint.constant
        
        btnNext.layer.cornerRadius = 10
    }
    
    func visibleLoginStatusMessgae(_ status: Bool) {
        switch status {
        case true:
            labelHidden.text = self.statusMessage
            labelHidden.isHidden = false
            if btnTopConstraint.constant == constraint {
                btnTopConstraint.constant += labelHidden.frame.height+10
            }
        case false:
            labelHidden.isHidden = true
            if btnTopConstraint.constant == constraint+labelHidden.frame.height+10 {
                btnTopConstraint.constant -= labelHidden.frame.height+10
            }
        }
    }
}


//MARK: 액션이벤트
extension JoinUserIDViewController {
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangedAction(_ sender: Any) {
        tfUserID.clearButtonMode = .whileEditing
        visibleLoginStatusMessgae(false)
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnNext:
            tfUserID.clearButtonMode = .never
            if idIsValidCheck(tfUserID.text!) {
                searchUserID()
                
//                performSegue(withIdentifier: "GoJoinFinalViewController", sender: nil)
                
            } else {
                self.statusMessage = "아이디는 영어, 숫자, '_', '.'만 사용 가능합니다."
                visibleLoginStatusMessgae(true)
            }
            
        default:
            return
        }
    }
        
    func idIsValidCheck(_ id: String) -> Bool {
        let str = "^[a-z0-9_.]*$"
        let predic = NSPredicate(format: "SELF MATCHES %@", str)

        return predic.evaluate(with: id)
    }
    
    func searchUserID() {
        if let userID = tfUserID.text  {
            APIUserGet().searchUserID(loginId: userID)

            return
        }
    }

}


extension JoinUserIDViewController {
    
    func searchUserIDsuccessAPI(_ result: UserResponseResult) {
        joinData.userID = tfUserID.text!
    }
    
    func searchUserIDfailureAPI(_ code: Int) {
        switch code {
        case 2103:
            print("파라미터 이상")
        case 2230:
            print("??")
//            self.statusMessage = "사용자 이름 \(tfUserID.text!)을를 사용할 수 없습니다."
//            visibleLoginStatusMessgae(true)
        default:
            print("!!")
//            self.statusMessage = "다른 아이디를 사용해주세요."
//            visibleLoginStatusMessgae(true)
        }
    }
}


extension JoinUserIDViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinFinalViewController" {
            let jFVC = segue.destination as! JoinFinalViewController
            jFVC.joinData = self.joinData
        }
    }
}
