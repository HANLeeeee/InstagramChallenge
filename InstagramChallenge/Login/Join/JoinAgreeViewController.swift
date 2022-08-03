//
//  JoinAgreeViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/29.
//

import UIKit
import SafariServices

class JoinAgreeViewController: UIViewController {
    @IBOutlet weak var btnRadioAll: UIButton!
    @IBOutlet var btnRadioS: [UIButton]!
    @IBOutlet var btnLinkS: [UIButton]!
    @IBOutlet weak var btnNext: UIButton!
    
    var joinData = UserPostRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUIJoinAgreeView()
    }
    
    //MARK: 화면UI변경
    func setUIJoinAgreeView() {
        btnHandler(btnRadioAll)
        btnRadioS.forEach {
            btnHandler($0)
        }
        
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
        btnNext.isEnabled = false
    }
    
    //라디오버튼 핸들러
    func btnHandler(_ btnChange: UIButton) {
        btnChange.configurationUpdateHandler = { btn in
            var config = UIButton.Configuration.plain()
            config.image = btn.isSelected ? UIImage(systemName: "checkmark.circle.fill")  : UIImage(systemName: "circle")
            config.baseBackgroundColor = .clear
            btn.configuration = config
        }
    }
}

extension JoinAgreeViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnRadioAll:
            if !btn.isSelected {
                btn.isSelected = true
                btnRadioS.forEach {
                    $0.isSelected = true
                    btnStatus(true)
                }
            } else {
                btn.isSelected = false
                btnRadioS.forEach {
                    $0.isSelected = false
                    btnStatus(false)
                }
            }
            
        case btnRadioS[0], btnRadioS[1], btnRadioS[2]:
            if !btn.isSelected {
                btn.isSelected = true
                if btnRadioS[0].isSelected && btnRadioS[1].isSelected && btnRadioS[2].isSelected {
                    btnStatus(true)
                }
            } else {
                btn.isSelected = false
                btnStatus(false)
            }
            
        case btnLinkS[0], btnLinkS[1], btnLinkS[2]:
            let url = NSURL(string: "https://gridgetest.oopy.io")
            let urlView: SFSafariViewController = SFSafariViewController(url: url! as URL)
            self.present(urlView, animated: true, completion: nil)
            
        case btnNext:
            performSegue(withIdentifier: "GoJoinUserIDViewController", sender: nil)
            
            
        default:
            return
        }
    }
    
    func btnStatus(_ selected: Bool) {
        switch selected {
        case true:
            btnNext.backgroundColor = UIColor.link
            btnNext.isEnabled = true
        case false:
            btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
            btnNext.isEnabled = false
        }
    }
}

extension JoinAgreeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinUserIDViewController" {
            let jIDVC = segue.destination as! JoinUserIDViewController
            jIDVC.joinData = self.joinData
        }
    }
}
