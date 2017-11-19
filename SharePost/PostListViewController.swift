//
//  PostListViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/11/3.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabaseUI
import FirebaseAuth
import SDWebImage

class PostListViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    var firebaseRef: DatabaseReference!
    var dataSource: FUITableViewDataSource!
    
   
    @IBAction func logoutClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTableView.estimatedRowHeight = 500
        postTableView.rowHeight = UITableViewAutomaticDimension
        
        firebaseRef = Database.database().reference().child("posts")
        
        self.dataSource = self.postTableView.bind(to: firebaseRef.queryOrdered(byChild: "ReversePostDate")) { tableView, indexPath, snap in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            
            let postData = snap.value as! [String: Any]
            let imgUrl = URL(string: (postData["imageURL"] as? String)!)
            
            cell.emailLabel.text = postData["email"] as? String
            cell.photoImageView.sd_setImage(with: imgUrl)
            cell.postMessageLabel.text = postData["postMsg"] as? String
            return cell
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postClick(_ sender: Any) {
       
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
