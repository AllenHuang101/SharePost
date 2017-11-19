//
//  LoggedInController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/10/29.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    var postReference: DatabaseReference!
    var postGuid: String = ""
    var postImageUrl: String = ""
    var postImagePath: String = ""
    let currentUser = (Auth.auth().currentUser)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let ref = Database.database().reference()
//
//        ref.observe(.childAdded) { (snapshot) in
//            debugPrint(snapshot.value)
//        }
//
//        let postRef = ref.childByAutoId()
//        postRef.updateChildValues([
//            "k1":"v1", "k2":"v2"
//            ])
        
        postReference = Database.database().reference().child("posts")
        setView()
    }

    func setView() {
        postTextView.setBorder(width: 2, radius: 10, color: UIColor.lightGray.cgColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutClick(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    

    @IBAction func addPhotoClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePictureAction = UIAlertAction(title: "拍照", style: .default) { action in
                print("拍照")
                
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
                
            }
            actionSheet.addAction(takePictureAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let choosePictureAction = UIAlertAction(title: "選取照片", style: .default) { action in
                print("選取照片")
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
            actionSheet.addAction(choosePictureAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            print("取消")
        }
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("選完照片")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("無法將照片轉成JPEG")
            return
        }
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: date)
        
        self.postGuid = UUID().uuidString
        self.postImagePath = "photos/\(currentUser.email!)/\(dateString)/\(postGuid).jpg"
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(postImagePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let metaData = metaData else{
                print("上傳失敗")
                return
            }
            
            print("上傳完成")
            
            guard let downloadUrl = metaData.downloadURL() else{
                print("取得下載網址失敗")
                return
            }
            
            self.postImageUrl = downloadUrl.absoluteString
        }
        
        self.imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("取消選取照片")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func publishPostClick(_ sender: Any) {
        let postRef = postReference.child(postGuid)
        
        let now = Date()
        let nowMS = Int(round(now.timeIntervalSince1970 * 1000))
        
        postRef.updateChildValues([
            "authorUID" : currentUser.uid,
            "email" : currentUser.email!,
            "imagePath" : postImagePath,
            "imageURL" : postImageUrl,
            "postMsg" : self.postTextView.text,
            "postDate" : nowMS
            ])
        
    }
}
