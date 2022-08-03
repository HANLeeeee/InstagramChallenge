//
//  FeedTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/02.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var comentHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUIFeedTableViewCell()
    }
    
    func setUIFeedTableViewCell() {
        comentHeight.constant += comentLabel.frame.height
    }
    
    func getRatio(_ image: UIImage) -> CGFloat {
        let widthRatio = CGFloat(image.size.width/image.size.height)
        return UIScreen.main.bounds.width / widthRatio
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
