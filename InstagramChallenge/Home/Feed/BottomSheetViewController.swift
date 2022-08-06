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
    var btnDidTabdDelegate: BtnDidTabdDelegate?
    var cellIndex: Int = 0

    @IBOutlet weak var bottomStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBottomSheetViewController()
    }
    
    func setUIBottomSheetViewController() {
        bottomStackView.layer.cornerRadius = 10
    }
}

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
