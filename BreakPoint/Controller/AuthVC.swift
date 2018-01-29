//
//  AuthVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/18/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func EmailLoginBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func facebookloginBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func googleloginBtnWasPressed(_ sender: Any) {
    }
}
