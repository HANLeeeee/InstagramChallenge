//
//  JoinPWViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class JoinPWViewController: UIViewController {
    @IBOutlet weak var tfPW: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var joinData = UserPostRequest()
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinPWViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: UI
    func setUIJoinPWViewController() {
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinBirthViewController" {
            let jBVC = segue.destination as! JoinBirthViewController
            jBVC.joinData = self.joinData
        }
    }
}




//MARK: IBAction
extension JoinPWViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnNext:
            if pwIsValidCheck(tfPW.text!) {
                joinData.userPW = tfPW.text!
                performSegue(withIdentifier: "GoJoinBirthViewController", sender: nil)
            } else {
                let alert = makeAlert("알림", "비밀번호를 확인해주세요", true, "확인")
                self.present(alert, animated: true)
            }
            
        default:
            return
        }
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 20 {
            textField.deleteBackward()
        }
        if textField.text!.count < 1 {
            btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnNext.isEnabled = false
        } else {
            btnNext.backgroundColor = UIColor.link
            btnNext.isEnabled = true
        }

    }
}




//MARK: 커스텀메소드
extension JoinPWViewController {
    func pwIsValidCheck(_ pw: String) -> Bool {
        let str = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,20}"
        let predic = NSPredicate(format: "SELF MATCHES %@", str)
        
        return predic.evaluate(with: pw)
    }
}

