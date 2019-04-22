//
//  ResourcesTabController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-17.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class MainTabController : UITabBarController {
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
