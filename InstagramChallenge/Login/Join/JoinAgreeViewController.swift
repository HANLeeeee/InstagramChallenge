//
//  JoinAgreeViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/29.
//

import UIKit
import SafariServices

class JoinAgreeViewController: UIViewController {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnRadioAll: UIButton!
    @IBOutlet var btnRadioS: [UIButton]!
    @IBOutlet var btnLinkS: [UIButton]!
    
    var joinData = UserPostRequest()

    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIJoinAgreeView()
    }
    
    //MARK: UI
    func setUIJoinAgreeView() {
        btnRadioAll.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        btnRadioAll.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        btnRadioS.forEach {
            $0.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            $0.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        }
        btnNext.backgroundColor = UIColor(named: "ColorBtnBefore")
        btnNext.layer.cornerRadius = 10
        btnNext.isEnabled = false
        
    }
    
    //MARK: 데이터전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoJoinUserIDViewController" {
            let jIDVC = segue.destination as! JoinUserIDViewController
            jIDVC.joinData = self.joinData
        }
    }
}




//MARK: IBAction
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
                btnRadioAll.isSelected = false
                btn.isSelected = true
                if btnRadioS[0].isSelected && btnRadioS[1].isSelected && btnRadioS[2].isSelected {
                    btnStatus(true)
                }
            } else {
                btnRadioAll.isSelected = false
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
}



//MARK: 커스텀메소드
extension JoinAgreeViewController {
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
