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
    @IBOutlet weak var btnKakaoLogin: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUIPagePhoneView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: UI
    func setUIPagePhoneView() {
        viewPhoneEdit.layer.borderColor = UIColor.systemGray5.cgColor
        viewPhoneEdit.layer.borderWidth = 0.5
        viewPhoneEdit.layer.cornerRadius = 10
        
        tfPhoneNum.text = ""
        
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinSMSViewController" {
            let JoinSMSViewController = segue.destination as! JoinSMSViewController
            JoinSMSViewController.resultPhoneNum = tfPhoneNum.text ?? ""
        }
    }
}





//MARK: IBAction
extension PagePhoneViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNext:
            performSegue(withIdentifier: "GoJoinSMSViewController", sender: nil)
            
        case btnKakaoLogin:
            print("카카오")
        default:
            return
        }
        
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 11 {
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
