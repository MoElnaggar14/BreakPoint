//
//  PostVC.swift
//  BreakPoint
//
//  Created by Mohammed Elnaggar on 1/23/18.
//  Copyright © 2018 Mohammed Elnaggar. All rights reserved.
//

import UIKit
import Firebase
class PostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textview.delegate = self
        sendBtn.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email 
    }

    @IBAction func SendPostBtnWasPressed(_ sender: Any) {
        if textview.text != nil && textview.text != "Say something here..." {
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(WithMessage: textview.text, forUID: (Auth.auth().currentUser?.uid)! , withGroupKey: nil, sendComplete: { (success) in
                if success {
                    dismiss(animated: true, completion: nil)
                    sendBtn.isEnabled = true
                } else {
                    sendBtn.isEnabled = false
                    print("there was error...")
                }
            })
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}


