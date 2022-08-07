//
//  FeedCommentsTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class FeedCommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelCoComment: UILabel!
    @IBOutlet weak var btnHeart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelCoComment.text = "답글 달기"
        btnHeart.backgroundImage(for: .normal)
    }
}
