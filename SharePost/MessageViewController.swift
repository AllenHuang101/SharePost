//
//  MessageViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/12/2.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseUI

class MessageViewController: UIViewController {
    var postId:String?
    var postData: [String : Any]?
    
    @IBOutlet weak var postLabel: UILabel!
    var dataSource: FUITableViewDataSource!
    var messageReference: DatabaseReference!
    let currentUser = (Auth.auth().currentUser)!
    

    @IBOutlet weak var postMsgLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!

    @IBOutlet weak var postNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let postData = postData {
            postMsgLabel.text = postData["postMsg"] as? String
            
        }
        
        
        messageReference = Database.database().reference().child("messages")
        
        self.dataSource = self.messageTableView.bind(to: messageReference.child(postId!), populateCell: { (tableView, indexPath, snap) -> UITableViewCell in
             let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            
             let messageData = snap.value as! [String: Any]
            
             cell.replyerLabel.text = messageData["replyer"] as? String
             cell.messageLabel.text = messageData["message"] as? String
             return cell
        })
        
    }

    @IBAction func messagePostClick(_ sender: Any) {
        let messageGuid = UUID().uuidString
        let messageRef = messageReference.child(postId!).child(messageGuid)
        
        messageRef.updateChildValues([
            "authorUID" : currentUser.uid,
            "replyer": currentUser.email,
            "message": messageTextView.text
            ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
