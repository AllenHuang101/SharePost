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
    var firebasePostsRef: DatabaseReference!
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
        
        firebasePostsRef = Database.database().reference().child("posts")
        
        self.dataSource = self.postTableView.bind(to: firebasePostsRef.queryOrdered(byChild: "ReversePostDate")) { tableView, indexPath, snap in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            
            let post = snap.value as! [String: Any]
    
            let imgUrl = URL(string: (post["imageURL"] as? String)!)
            
            if let authorUid = post["authorUID"] as? String {
                let personalReference = Database.database().reference().child("personals").child(authorUid)
                
                personalReference.observeSingleEvent(of: .value, with: { (snap) in
                    guard let personal = snap.value as? [String: Any] else{
                        print("Error!")
                        return
                    }
                    
                    if let url = personal["personalImageUrl"] as? String {
                        let imgUrl = URL(string: (personal["personalImageUrl"] as? String)!)
                        cell.personalPhotoImageView.sd_setImage(with: imgUrl)
                    }
                })
            }
           
            cell.emailLabel.text = post["email"] as? String
            cell.photoImageView.sd_setImage(with: imgUrl)
            cell.postMessageLabel.text = post["postMsg"] as? String
            
            if let heartCount = post["heartCount"] as? Int {
                cell.heartCountButton.isHidden = false
                cell.heartCountTitleLabel.isHidden = false
                cell.heartCountButton.setTitle("\(String(heartCount))", for: .normal)
            }else{
                //hide heart count
                cell.heartCountTitleLabel.isHidden = true
                cell.heartCountButton.isHidden = true
            }
            
            self.postIdDict.updateValue(snap.key, forKey: indexPath.row)
            self.postDataDict.updateValue(post, forKey: indexPath.row)
            
            debugPrint(post)
            
            //post id
            cell.postIdLabel.text = snap.key
            cell.heartCountButton.tag = indexPath.row
            cell.messageButton.tag = indexPath.row

            return cell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "messageSegueIdentifier") {
            let tag = (sender as! UIButton).tag
            if let destination = segue.destination as? MessageViewController {
                print(self.postIdDict[tag])
                
                destination.postId = self.postIdDict[tag]
                destination.postData = self.postDataDict[tag]
            }
        }else if(segue.identifier == "heartSegueIdentifier") {
            let tag = (sender as! UIButton).tag
            if let destination = segue.destination as? HeartViewController {
                destination.postId = self.postIdDict[tag]
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
