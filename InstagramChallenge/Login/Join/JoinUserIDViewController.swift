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
    var statusMessage: String = ""
    var joinData = UserPostRequest()
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinUserIDViewController()
    }
    
    //MARK: UI
    func setUIJoinUserIDViewController() {
        constraint = btnTopConstraint.constant
        btnNext.layer.cornerRadius = 10
    }
    
    func visibleLoginStatusMessgae(_ status: Bool) {
        switch status {
        case true:
            labelHidden.text = statusMessage
            labelHidden.isHidden = false
            tfUserID.layer.cornerRadius = 10
            tfUserID.layer.borderWidth = 1
            tfUserID.layer.borderColor = UIColor.red.cgColor
            if btnTopConstraint.constant == constraint {
                btnTopConstraint.constant += labelHidden.frame.height+10
            }
        case false:
            labelHidden.isHidden = true
            tfUserID.layer.borderWidth = 0
            if btnTopConstraint.constant == constraint+labelHidden.frame.height+10 {
                btnTopConstraint.constant -= labelHidden.frame.height+10
            }
        }
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinFinalViewController" {
            let jFVC = segue.destination as! JoinFinalViewController
            jFVC.joinData = self.joinData
        }
    }
}




//MARK: IBAction
extension JoinUserIDViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnNext:
            if idIsValidCheck(tfUserID.text!) {
                searchUserID()
                
            } else {
                self.statusMessage = "아이디는 영어, 숫자, '_', '.'만 사용 가능합니다."
                visibleLoginStatusMessgae(true)
            }
            
        default:
            return
        }
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChagedAction(_ sender: Any) {
        visibleLoginStatusMessgae(false)
    }
}




//MARK: 회원 검색
extension JoinUserIDViewController {
    func searchUserID() {
        if let userID = tfUserID.text  {
            APIUserGet().searchUserID(loginId: userID, completion: { result in
                switch result {
                case .success(let result):
                    print(result)
                    if result.isSuccess {
                        self.joinData.userID = userID
                        self.performSegue(withIdentifier: "GoJoinFinalViewController", sender: nil)
                        
                    } else {
                        switch result.code {
                        case 2230:
                            self.statusMessage = "사용자 이름 \(userID)을(를) 사용할 수 없습니다."
                            self.visibleLoginStatusMessgae(true)
                        default:
                            self.statusMessage = "다른 아이디를 사용해주세요."
                            self.visibleLoginStatusMessgae(true)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
            return
        }
    }
}



//MARK: 커스텀메소드
extension JoinUserIDViewController {
    func idIsValidCheck(_ id: String) -> Bool {
        let str = "^[a-z0-9_.]*$"
        let predic = NSPredicate(format: "SELF MATCHES %@", str)

        return predic.evaluate(with: id)
    }
}
