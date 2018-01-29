//
//  CreateGroupsVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/26/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController{

    @IBOutlet weak var titleTF: InsertTextFiled!
    @IBOutlet weak var descriptionTF: InsertTextFiled!
    @IBOutlet weak var addPeopleTF: InsertTextFiled!
    @IBOutlet weak var addtogroupLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    var emailArray = [String]()
    var choosenArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addPeopleTF.delegate = self
        addPeopleTF.addTarget(self, action: #selector(texteditingChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }

    @objc func texteditingChange() {
        if addPeopleTF.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: addPeopleTF.text!, handler: { (reternedEmailArray) in
                self.emailArray = reternedEmailArray
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
        if titleTF.text != "" && descriptionTF.text != "" {
            DataService.instance.getIds(foruserNames: choosenArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createGroup(title: self.titleTF.text!, description: self.descriptionTF.text!, forIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "group cancot created, please try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}


extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileimage = UIImage(named: "defaultProfileImage")
        if choosenArray.contains(emailArray[indexPath.row]) {
        cell.configureCell(ProfileImage: profileimage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
          cell.configureCell(ProfileImage: profileimage!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !choosenArray.contains(cell.emailLbl.text!) {
            choosenArray.append(cell.emailLbl.text!)
            addtogroupLbl.text = choosenArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            choosenArray = choosenArray.filter({ $0 != cell.emailLbl.text })
            if choosenArray.count >= 1 {
                addtogroupLbl.text = choosenArray.joined(separator: ", ")
            } else {
                addtogroupLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
            
        }
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    
}







