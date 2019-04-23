//
//  RegisterViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-18.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import MaterialComponents.MaterialSnackbar
import Lottie

class RegisterViewController: UIViewController {
    
    var animationView: AnimationView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        createLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30).isActive = true
        createLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 30).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        confirmPasswordTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30).isActive = true
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30).isActive = true
        
        backButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 10).isActive = true
        backButton.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 10.0)
        
        signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 10).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor).isActive = true
        signupButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        super.updateViewConstraints()
    }
    
    @IBAction func backToSignin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func register(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirm = confirmPasswordTextField.text,
            let name = nameTextField.text else {
                return
        }
        
        if (name.isEmpty) {
            registerAlert(message: "Please enter your name")
        } else if (email.isEmpty) {
            registerAlert(message: "Please enter email address")
        } else if (password.isEmpty || password.count < 6 || password != confirm) {
            registerAlert(message: "Password must be at least 6 character and both must match")
        } else {
            self.registering(message: nil)
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                guard let authResult = authResult, error == nil else {
                    strongSelf.registerAlert(message: error!.localizedDescription)
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                self?.registering(message: "Updating profile...")
                changeRequest?.commitChanges { (error) in
                    if (error != nil) {
                        self?.registerAlert(message: error!.localizedDescription)
                        return
                    } else {
                        strongSelf.dismiss(animated: true, completion: nil)
                        strongSelf.emailTextField.text = ""
                        strongSelf.passwordTextField.text = ""
                        strongSelf.confirmPasswordTextField.text = ""
                        strongSelf.nameTextField.text = ""
                    }
                }
            }
        }
    }
    
    func registerAlert(message: String) {
        let snack = MDCSnackbarMessage()
        snack.text = message
        MDCSnackbarManager.show(snack)
    }
    
    func registering(message: String?) {
        let snack = MDCSnackbarMessage()
        snack.text = message ?? "Registering account..."
        MDCSnackbarManager.show(snack)
    }
}
