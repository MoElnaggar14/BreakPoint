//
//  GroupFeedVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/28/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var sendMessageTF: InsertTextFiled!
    
    var group: Group?
    var groupMessages = [Message]()
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        sendBtnView.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmail(forGroup: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
            DataService.instance.getAllGroupMessage(desiredGroup: self.group!, handler: { (returnGroupMessages) in
                self.groupMessages = returnGroupMessages
                self.tableView.reloadData()
            })
        }
        
        if self.groupMessages.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1 , section: 0), at: .none, animated: true)
        }
        
    }

    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetails()
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if sendMessageTF.text != "" {
            sendMessageTF.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(WithMessage: sendMessageTF.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (complete) in
                if complete {
                    self.sendMessageTF.text = ""
                    self.sendMessageTF.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            })
        }
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderId) { (email) in
             cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
       
        return cell
    }
}
