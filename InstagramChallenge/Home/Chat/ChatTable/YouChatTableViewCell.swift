//
//  ChatTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class YouChatTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelYouChat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIYouChatTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: UI
    func setUIYouChatTableViewCell() {
        viewBg.layer.cornerRadius = 20
        viewBg.layer.borderWidth = 1
        viewBg.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewProfile.image = UIImage()
        labelYouChat.text = ""
    }
}
