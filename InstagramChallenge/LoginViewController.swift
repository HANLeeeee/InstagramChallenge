//
//  ViewController.swift
//  InstagramChallenge
//
//  Created by 하늘이 on 2022/07/26.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldID: UITextField!
    @IBOutlet weak var textFieldPW: UITextField!
    
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardObserverRemove()
    }
    
    @IBAction func bgViewTab(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tfEditingChangeAction(_ textField: UITextField) {
        if textField.text!.count > 20 {
            textField.deleteBackward()
        }
    }
}

//MARK: 버튼클릭액션
extension LoginViewController {
 
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnEye:
            btnEyeTouchUp(btn)
            
        default:
            return
        }
    }
    
    func btnEyeTouchUp(_ btn: UIButton) {
        if btn.isSelected {
            btn.isSelected = false
            btn.setBackgroundImage(UIImage(named: "icon_eye"), for: .selected)
            textFieldPW.isSecureTextEntry = true
            
        } else {
            btn.isSelected = true
            btn.setBackgroundImage(UIImage(named: "icon_eyeSlash"), for: .normal)
            textFieldPW.isSecureTextEntry = false
            
        }
    }
}

//MARK: 키보드옵저버
extension LoginViewController {
    func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        if self.constraint.constant != 0 {
            self.constraint.constant -= 100
        }
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        self.constraint.constant += 100
    }
}
