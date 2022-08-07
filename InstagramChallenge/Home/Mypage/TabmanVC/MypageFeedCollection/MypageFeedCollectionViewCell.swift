//
//  MypageFeedCollectionViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import UIKit

class MypageFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIMypageFeedCollectionViewCell()
    }
    
    //MARK: UI
    func setUIMypageFeedCollectionViewCell() {
        imageViewWidth.constant = UIScreen.main.bounds.width / 3
    }
}
