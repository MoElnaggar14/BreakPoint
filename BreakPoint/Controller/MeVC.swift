//
//  MeVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/23/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
    }

    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "logout?", style: .destructive, handler: { (action) in
            do {
            try Auth.auth().signOut()
            } catch let err as NSError {
                print(err.debugDescription)
            }
            let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
            self.present(authVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    

}
