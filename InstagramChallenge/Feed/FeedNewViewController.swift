//
//  FeedNewViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import UIKit

class FeedNewViewController: UIViewController {

    @IBOutlet weak var barbtnBack: UIBarButtonItem!
    @IBOutlet weak var barbtnNext: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FeedNewViewController {
    @IBAction func barbtnAction(_ barbtn: UIBarButtonItem) {
        switch barbtn {
        case barbtnBack:
            self.navigationController?.popViewController(animated: true)

        case barbtnNext:
            print("다음")
            self.navigationController?.popToRootViewController(animated: true)

            
        default:
            return
        }
        
    }
}
