//
//  JoinBirthViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/29.
//

import UIKit

class JoinBirthViewController: UIViewController {
    @IBOutlet weak var viewBirth: UIView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var labelBirth: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    var joinData = UserPostRequest()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIJoinBirthView()
    }

    //MARK: 화면UI변경
    func setUIJoinBirthView() {
        viewBirth.layer.borderWidth = 1
        viewBirth.layer.borderColor = UIColor.tintColor.cgColor
        viewBirth.layer.cornerRadius = 5
        
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
        
        labelAge.text = ""
        
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        labelBirth.text = formatter.string(from: datepicker.date)
        
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        labelBirth.textColor = .black
        labelBirth.text = formatter.string(from: datepicker.date)
        
        let age = Calendar.current.dateComponents([.year], from: datepicker.date, to: Date())
        
        if Date() > datepicker.date {
            if case let (y?) = (age.year) {
                labelAge.text = "\(y+1)세"
            }
            btnNext.backgroundColor = UIColor.link
            btnNext.isEnabled = true
        } else {
            btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnNext.isEnabled = false
            labelAge.text = ""

        }
    }
}

extension JoinBirthViewController {
    @IBAction func bgViewBirthTab(_ sender: Any) {
        datepicker.isHidden = false
        if viewBottomConstraint.constant == 0 {
            viewBottomConstraint.constant += datepicker.frame.height
        }
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnNext:
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy.MM.dd"
            let userBirth = dateformatter.string(from: datepicker.date)

            joinData.userBirth = userBirth
            performSegue(withIdentifier: "GoJoinAgreeViewController", sender: nil)
            
        default:
            return
        }
        
    }
    
}

extension JoinBirthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinAgreeViewController" {
            let jAVC = segue.destination as! JoinAgreeViewController
            jAVC.joinData = self.joinData
        }
    }
}
