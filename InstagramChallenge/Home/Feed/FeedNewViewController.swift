//
//  FeedNewViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import UIKit

class FeedNewViewController: UIViewController {

    @IBOutlet weak var barbtnNext: UIBarButtonItem!
    
    var pickImage = UIImage()
    @IBOutlet weak var imageViewPickImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUIFeedNewViewController() {
        imageViewPickImage.image = pickImage
    }

}

extension FeedNewViewController {
    @IBAction func tabBackView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func barbtnAction(_ barbtn: UIBarButtonItem) {
        switch barbtn {
        case barbtnNext:
            print("다음")
            self.navigationController?.popToRootViewController(animated: true)

            
        default:
            return
        }
        
    }
}
