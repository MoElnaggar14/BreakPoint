//
//  GroupCell.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/28/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescriptionLbl: UILabel!
    @IBOutlet weak var groupMembersCountLbl: UILabel!
    
    func configureCell(title: String, description: String, membersCount: Int){
        self.groupTitleLbl.text = title
        self.groupDescriptionLbl.text = description
        self.groupMembersCountLbl.text = "\(membersCount) members."
        
    }
}
