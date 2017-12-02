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
    var postIdDict = [Int:String]()
    var postDataDict = [Int: [String: Any]]()
    
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
            
            self.postIdDict.updateValue(snap.key, forKey: indexPath.row)
            self.postDataDict.updateValue(postData, forKey: indexPath.row)
            
            cell.messageButton.tag = indexPath.row
            cell.messageButton.addTarget(self,action:#selector(PostListViewController.messageClick(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }

    @objc func messageClick(_ sender: Any)
    {
        print("123")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "messageSegueIdentifier") {
            let tag = (sender as! UIButton).tag
            if let destination = segue.destination as? MessageViewController {
                print(self.postIdDict[tag])
                
                destination.postId = self.postIdDict[tag]
                destination.postData = self.postDataDict[tag]
            }
        }
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
