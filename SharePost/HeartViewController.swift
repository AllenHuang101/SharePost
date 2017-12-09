//
//  HeartViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/12/9.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseDatabaseUI

class HeartViewController: UIViewController {
    var dataSource: FUITableViewDataSource!
    var heartRef: DatabaseReference!
     var postId:String?
    
    @IBOutlet weak var heartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        heartRef = Database.database().reference().child("hearts")
        
        self.dataSource = self.heartTableView.bind(to: heartRef.child(postId!), populateCell: { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeartCell", for: indexPath) as! HeartCell
            
            debugPrint(snap.value)
            //let heartData = snap.value as? [String: Any]
            
            
            if let heartData = snap.value as? [String: Any] {
                let userId = snap.key
                let personalReference = Database.database().reference().child("personals").child(userId)
                
                personalReference.observeSingleEvent(of: .value, with: { (snap) in
                    guard let personal = snap.value as? [String: Any] else{
                        print("Error!")
                        return
                    }
                    
                    if let url = personal["personalImageUrl"] as? String {
                        let imgUrl = URL(string: (personal["personalImageUrl"] as? String)!)
                        cell.photoImageView.sd_setImage(with: imgUrl)
                    }
                    
                    cell.emailLabel.text = personal["email"] as! String
                })
            }
            
            return cell
        })
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
