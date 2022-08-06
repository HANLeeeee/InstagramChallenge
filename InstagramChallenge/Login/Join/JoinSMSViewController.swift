//
//  JoinSMSViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class JoinSMSViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tfSMSNum: UITextField!
    @IBOutlet weak var btnPhoneNumChange: UIButton!
    @IBOutlet weak var btnSMSRetry: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var resultPhoneNum: String = ""
    var joinData = UserPostRequest()
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinSMSView()
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
    func setUIJoinSMSView() {
        labelTitle.text = "+82\(resultPhoneNum)번으로 \n 전송된 인증 코드를 입력하세요"
        
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinNameViewController" {
            let jNVC = segue.destination as! JoinNameViewController
            jNVC.joinData = self.joinData
        }
    }
}




//MARK: IBAction
extension JoinSMSViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnPhoneNumChange, btnSMSRetry, btnBack:
            self.navigationController?.popViewController(animated: true)
            
        case btnNext:
            if tfSMSNum.text == "123456" {
                joinData.userPN = resultPhoneNum
                performSegue(withIdentifier: "GoJoinNameViewController", sender: nil)
            } else {
                let alert = makeAlert("알림", "인증번호가 틀렸습니다", true, "확인")
                present(alert, animated: false)
                tfSMSNum.text = ""
            }
                
        default:
            return
        }
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 6 {
            textField.deleteBackward()
        }
        if textField.text!.count == 6 {
            btnNext.backgroundColor = UIColor.link
            btnNext.isEnabled = true
        } else {
            btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnNext.isEnabled = false
        }
    }
}
