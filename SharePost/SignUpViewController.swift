//
//  SignUpViewController.swift
//  SharePost
//
//  Created by allen3_huang on 2017/10/29.
//  Copyright © 2017年 allen3_huang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpClick(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            print("Email 或 密碼輸入錯誤")
            return
        }
        
        if password != confirmPassword {
            print("兩次輸入密碼不同")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                print("註冊發生錯誤")
                if let error = error {
                    debugPrint(error)
                }
                return
            }
            print("註冊成功！")
             debugPrint(user.email!, user.uid)
        }
    }

    @IBAction func backToSignInClick(_ sender: Any) {
    }
}
