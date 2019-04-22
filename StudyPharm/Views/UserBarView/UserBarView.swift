//
//  UserBarView.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class UserBarView: UIView {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var signoutButton: UIButton!
    
    @IBAction func signoutClicked(_ sender: Any) {
        print("signingout")
        do {
            try Auth.auth().signOut()
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let currentController = self.getCurrentViewController()
            currentController?.present(loginController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let _ = loadViewFromNib()
        let user = Auth.auth().currentUser
        if user != nil {
            emailLabel.text = user!.email
            displaynameLabel.text = user?.displayName ?? "John Smith"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot be created from storyboard")
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "UserBarView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        return view
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
}
