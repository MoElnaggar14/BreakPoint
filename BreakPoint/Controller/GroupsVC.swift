//
//  GroupsVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/17/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var groupTableView: UITableView!
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
            DataService.instance.getAllGroups { (returnedGroups) in
                self.groupsArray = returnedGroups
                self.groupTableView.reloadData()
            }

        }
    }


}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDescription, membersCount: group.membersCount)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let groupFeedVc = storyBoard.instantiateViewController(withIdentifier: "GroupFeedVC") as! GroupFeedVC
        groupFeedVc.initData(forGroup: groupsArray[indexPath.row])
        presentDetails(viewControllerToPresent: groupFeedVc)
    }
}
