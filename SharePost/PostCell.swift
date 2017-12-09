//
//  PostCellTableViewCell.swift
//  SharePost
//
//  Created by allen3_huang on 2017/11/3.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostCell: UITableViewCell {
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var heartCountButton: UIButton!
    @IBOutlet weak var heartCountTitleLabel: UILabel!
    @IBOutlet weak var postIdLabel: UILabel!
    @IBOutlet weak var personalPhotoImageView: UIImageView!
    @IBOutlet weak var postMessageLabel: UILabel!
    let currentUser = (Auth.auth().currentUser)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func heartClick(_ sender: Any) {
        if let postId = postIdLabel.text {
            var postsRef = Database.database().reference().child("posts")
            var postRef = postsRef.child(postId)
            
            print(heartCountButton.titleLabel?.text)
            
            if let heartCountStr = heartCountButton.titleLabel?.text, let heartCount = Int(heartCountStr) {
                postRef.updateChildValues([
                    "heartCount":heartCount + 1
                    ])
                

                var userId = currentUser.uid
                var heartPostRef = Database.database().reference().child("hearts").child(postId).child(userId)
                
                
                
                //print((Auth.auth().currentUser)!)
                heartPostRef.updateChildValues([
                    "userId": currentUser.email
                    ])
            }
        }
        
        print(postIdLabel.text)
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
