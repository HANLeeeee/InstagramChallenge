//
//  MeChatTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import UIKit

class MeChatTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var labelMeChat: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIMeChatTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUIMeChatTableViewCell() {
        viewBg.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelMeChat.text = ""
    }
}
