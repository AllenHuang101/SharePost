//
//  SignInViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/10/29.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInClick(_ sender: Any) {
        
       
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Email 或 密碼輸入錯誤")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                print("登入發生錯誤")
                if let error = error {
                    debugPrint(error)
                }
                return
            }
            print("登入成功！")
            debugPrint(user.email!, user.uid)
            
            let postListNav = self.storyboard?.instantiateViewController(withIdentifier: "PostListNav") as! UINavigationController
            self.present(postListNav, animated: true, completion: nil)
        }
    }    
}
