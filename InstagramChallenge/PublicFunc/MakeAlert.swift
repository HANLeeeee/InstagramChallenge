//
//  alert.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import Foundation
import UIKit


public func makeAlert(_ alertTitle: String, _ alertMessage: String, _ btnCancle: Bool, _ btnCancleTitle: String?) -> UIAlertController {
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    
    if btnCancle {
        let cancle = UIAlertAction(title: btnCancleTitle, style: .default)
        alert.addAction(cancle)
    }
    
    return alert
}
