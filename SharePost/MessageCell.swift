//
//  MessageCellTableViewCell.swift
//  SharePost
//
//  Created by allen3_huang on 2017/12/2.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

  
    @IBOutlet weak var replyerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
