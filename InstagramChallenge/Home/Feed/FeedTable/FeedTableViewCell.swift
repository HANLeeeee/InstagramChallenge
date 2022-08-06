//
//  FeedTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/02.
//

import UIKit

protocol BtnMoreDelegate {
    func btnMoreAction(index: Int)
    func btnCommentsAction(index: Int)
}

class FeedTableViewCell: UITableViewCell {
    var btnMoreDelegate: BtnMoreDelegate?
    var cellIndex: Int = 0

    @IBOutlet weak var labelfeedLoginId: UILabel!
    @IBOutlet weak var labelfeedIdplusText: UILabel!
    @IBOutlet weak var labelfeedCreatedAt: UILabel!
    @IBOutlet weak var labelfeedCommentCount: UILabel!
    @IBOutlet weak var labelLikeCount: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet var btnCommentS: [UIButton]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnMoreAction(_ sender: Any) {
        self.btnMoreDelegate?.btnMoreAction(index: cellIndex)
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn {
        case btnCommentS[0], btnCommentS[1], btnCommentS[2]:
            self.btnMoreDelegate?.btnCommentsAction(index: cellIndex)
            
        default:
            return
        }
    }
}
