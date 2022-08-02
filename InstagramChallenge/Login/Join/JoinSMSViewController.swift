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
    
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIJoinSMSView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: 화면UI변경
    func initUIJoinSMSView() {
        labelTitle.text = "+82\(resultPhoneNum)번으로 \n 전송된 인증 코드를 입력하세요"
    }
}

//MARK: 액션이벤트
extension JoinSMSViewController {
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 6 {
            textField.deleteBackward()
        }
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnPhoneNumChange, btnSMSRetry, btnBack:
            self.navigationController?.popViewController(animated: true)
            
        case btnNext:
            if tfSMSNum.text == "123456" {
                
            } else {
                let alert = makeAlert("알림", "인증번호가 틀렸습니다", true, "확인")
                present(alert, animated: false)
                tfSMSNum.text = ""
                
            }
                
            
        default:
            return
        }
    }
}
