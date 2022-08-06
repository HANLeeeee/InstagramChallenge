//
//  JoinNameViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class JoinNameViewController: UIViewController {
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var joinData = UserPostRequest()
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinNameViewController()
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
    func setUIJoinNameViewController() {
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinPWViewController" {
            let jPWVC = segue.destination as! JoinPWViewController
            jPWVC.joinData = self.joinData
        }
    }
}




//MARK: IBAction
extension JoinNameViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnLogin:
            self.navigationController?.popToRootViewController(animated: true)
            
        case btnNext:
            //다음버튼을 눌렀을 때 카카오가입하기와 일반가입하기 나누기
            
            joinData.userName = tfUserName.text!
            performSegue(withIdentifier: "GoJoinPWViewController", sender: nil)
        

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
