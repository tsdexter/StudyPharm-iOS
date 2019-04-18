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
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        signinLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        let logoAnimation = Animation.named("heartrate", subdirectory: "animations")
        animationView = AnimationView()
        animationView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 200)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        animationView.animation = logoAnimation
        animationView.play()
        
        view.addSubview(animationView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        signinLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30).isActive = true
        signinLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: signinLabel.bottomAnchor, constant: 30).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        signupButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 10.0)
        
        signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        signinButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        signinButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        super.updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // listen for auth changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth state changed")
            
            // if user is logged in, redirect to main view
            if let user = user {
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
        resourcesTabController.selectedViewController = resourcesTabController.viewControllers?[0]
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

