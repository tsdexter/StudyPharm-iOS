//
//  ViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-17.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MaterialComponents.MaterialSnackbar

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // listen for auth changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth state changed")
            
            // if user is logged in, redirect to main view
            if let user = user {
                let uid = user.uid
                let email = user.email
                let name = user.displayName
                print(uid + email! + name!)
                self.redirect()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        if (email.isEmpty) {
            loginAlert(message: "Please enter email address")
        } else if (password.isEmpty || password.count < 6) {
            loginAlert(message: "Password must be at least 6 characters")
        } else {
            self.authenticating()
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    strongSelf.loginAlert(message: error.localizedDescription)
                    return
                } else {
                    strongSelf.emailTextField.text = ""
                    strongSelf.passwordTextField.text = ""
                }
            }
        }
    }
    
    func redirect() {
        let resourcesTabController = storyboard?.instantiateViewController(withIdentifier: "ResourcesTabController") as! ResourcesTabController
        resourcesTabController.selectedViewController = resourcesTabController.viewControllers?[1]
        present(resourcesTabController, animated: true, completion: nil)
    }
    
    func loginAlert(message: String) {
        let snack = MDCSnackbarMessage()
        snack.text = message
        MDCSnackbarManager.show(snack)
    }
    
    func authenticating() {
        let message = MDCSnackbarMessage()
        message.text = "Authenticating..."
        MDCSnackbarManager.show(message)
    }
    
}

