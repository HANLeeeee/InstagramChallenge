//
//  BottomSheetViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

protocol BtnDidTabdDelegate {
    func btnModifyAction(index: Int)
    func btnRemoveAction(index: Int)
}

class BottomSheetViewController: UIViewController {
    @IBOutlet var btnS: [UIButton]!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet var stackViewS: [UIStackView]!
    
    var btnDidTabdDelegate: BtnDidTabdDelegate?
    var cellIndex: Int = 0

    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBottomSheetViewController()
    }
    
    //MARK: UI
    func setUIBottomSheetViewController() {
        stackViewS.forEach {
            $0.layer.cornerRadius = 10
        }
    }
}



//MARK: IBAction
extension BottomSheetViewController {
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnS[0]:
            print("수정")
            dismiss(animated: true)
            self.btnDidTabdDelegate?.btnModifyAction(index: cellIndex)

        case btnS[1]:
            print("삭제")
            dismiss(animated: true)
            self.btnDidTabdDelegate?.btnRemoveAction(index: cellIndex)

        default:
            return
        }
        
    }
}
