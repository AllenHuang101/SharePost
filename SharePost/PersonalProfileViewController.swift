//
//  PersonalProfileViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/12/3.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PersonalProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var personalImage: UIImageView!
    var personalsReference: DatabaseReference!
    var personalReference: DatabaseReference!
    var currentUser: User?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentUser = (Auth.auth().currentUser)!
        personalsReference = Database.database().reference().child("personals")
        
        personalReference = personalsReference.child(currentUser!.uid)
        
        setUpView()
    }
    
    func setUpView(){
        personalReference.observeSingleEvent(of: .value, with: { (snap) in
  
            guard let personalData = snap.value as? [String: Any] else{
                print("Error!")
                return
            }
            
            if let url = personalData["personalImageUrl"] as? String {
                 let imgUrl = URL(string: (personalData["personalImageUrl"] as? String)!)
                 self.personalImage.sd_setImage(with: imgUrl)
            }
           
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {

        
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            print("圖片有問題")
            return
        }
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("無法將照片轉成JPEG")
            return
        }
        
        personalImage.image = image
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: date)
        
        let uuid = UUID().uuidString
        let personalImagePath = "personal/\(currentUser!.email!)/\(uuid).jpg"
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(personalImagePath)
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
            
            let personalRef = self.personalsReference.child(self.currentUser!.uid)
            personalRef.updateChildValues([
                "uuid" : self.currentUser!.uid,
                "email" : self.currentUser!.email!,
                "personalImagePath" : personalImagePath,
                "personalImageUrl" : downloadUrl.absoluteString
                ])
            
            print(downloadUrl.absoluteString)
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func personalImageClick(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
