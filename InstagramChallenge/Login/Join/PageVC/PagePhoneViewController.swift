//
//  PagePhoneViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class PagePhoneViewController: UIViewController {

    @IBOutlet weak var viewPhoneEdit: UIView!
    @IBOutlet weak var tfPhoneNum: UITextField!
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUIPagePhoneView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    //MARK: 화면UI변경
    func initUIPagePhoneView() {
        viewPhoneEdit.layer.borderColor = UIColor.systemGray5.cgColor
        viewPhoneEdit.layer.borderWidth = 0.5
        viewPhoneEdit.layer.cornerRadius = 10
        
        tfPhoneNum.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinSMSViewController" {
            let JoinSMSViewController = segue.destination as! JoinSMSViewController
            JoinSMSViewController.resultPhoneNum = tfPhoneNum.text ?? ""
        }
    }
}

//MARK: 액션이벤트
extension PagePhoneViewController {
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 11 {
            textField.deleteBackward()
        }
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNext:
            print("다음")
            
        default:
            return
        }
        
    }
}
