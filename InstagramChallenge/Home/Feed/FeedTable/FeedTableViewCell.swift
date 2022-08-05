//
//  FeedTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/02.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelfeedLoginId: UILabel!
    @IBOutlet weak var labelfeedIdplusText: UILabel!
    @IBOutlet weak var labelfeedCreatedAt: UILabel!
    @IBOutlet weak var labelfeedCommentCount: UILabel!
    @IBOutlet weak var labelLikeCount: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func getRatio(_ image: UIImage) -> CGFloat {
        let widthRatio = CGFloat(image.size.width/image.size.height)
        return UIScreen.main.bounds.width / widthRatio
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
