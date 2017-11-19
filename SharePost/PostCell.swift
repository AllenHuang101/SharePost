//
//  PostCellTableViewCell.swift
//  SharePost
//
//  Created by allen3_huang on 2017/11/3.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var postMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
