//
//  LoginVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/18/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: InsertTextFiled!
    @IBOutlet weak var passwordTF: InsertTextFiled!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
    }

    @IBAction func signInBtnWasPressed(_ sender: Any) {
        if emailTF.text != nil && passwordTF.text != nil {
            AuthService.instance.loginUser(withEmail: emailTF.text!, andPassword: passwordTF.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                AuthService.instance.registerUser(withEmail: self.emailTF.text!, andPassword:self.passwordTF.text!, userCreationComplete: { (success, registerError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTF.text!, andPassword: self.passwordTF.text!, loginComplete: { (success, nil) in
                            let alert = UIAlertController(title: "Congrats!", message: "Successfully, registered user", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                             self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        })
                    } else {
                        print(String(describing: registerError?.localizedDescription))
                    }
                })
            })
        }
    }
  
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate { }
