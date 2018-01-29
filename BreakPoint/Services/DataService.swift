//
//  DataService.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/18/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED:DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ userName: String)-> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userNameSnapShot) in
            guard let userNameSnapShot = userNameSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userNameSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(WithMessage message: String, forUID uid: String, withGroupKey groupkey: String?, sendComplete: (_ status: Bool) -> ()) {
        if groupkey != nil {
            REF_GROUPS.child(groupkey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message,"senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllGroupMessage(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message])->()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessagesSnapShot) in
            guard let groupMessagesSnapShot = groupMessagesSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for groupMessage in groupMessagesSnapShot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMesaageSnapShot) in
            guard let feedMesaageSnapShot = feedMesaageSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for message in feedMesaageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String])->()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userDataSnap) in
            guard let userDataSnap = userDataSnap.children.allObjects as? [DataSnapshot] else {return}
            for user in userDataSnap {
                let email = user.childSnapshot(forPath: "email").value as! String
                if  email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(foruserNames usernames: [String], handler: @escaping (_ uidArray: [String])-> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            var idArray = [String]()
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
           handler(idArray)
        }
    }
    
    func getEmail(forGroup group : Group, handler: @escaping (_ emailArray: [String])->()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(title: String, description: String, forIds ids: [String], handler: @escaping (_ groupCreated: Bool)->()){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping ([Group])->() ) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapShot) in
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapShot {
                let title = group.childSnapshot(forPath: "title").value as! String
                let description = group.childSnapshot(forPath: "description").value as! String
                let membersArray = group.childSnapshot(forPath: "members").value as! [String]
                let group = Group.init(title: title, description: description, key: group.key, membersCount: membersArray.count, members: membersArray)
                groupsArray.append(group)
            }
            handler(groupsArray)
        }
    }
    
}












