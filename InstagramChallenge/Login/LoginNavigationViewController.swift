//
//  LoginNavigationViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import UIKit
import UserNotifications

class LoginNavigationViewController: UINavigationController {
    let userNotificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
