//
//  ViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 6/20/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import TextFieldFloatingPlaceholder
import Firebase
import SwiftKeychainWrapper

@available(iOS 13.0, *)
class SignInViewController: UIViewController {

    @IBOutlet weak var emailInput: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordInput: TextFieldFloatingPlaceholder!
    
    @IBOutlet weak var signInButton: AddButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var shouldPresentAlert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        createAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
        forgotPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        signInButton.imageView?.contentMode = .scaleAspectFit
        signInButton.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        isModalInPresentation = true
        
        //Adding so the user can dismiss the keyboard by tapping the screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("ERIC: ID found in keychain")
            performSegue(withIdentifier: "goToNewFeed", sender: nil)
        }
        
        if shouldPresentAlert == true {
                  //present alert
                  print("PRESENT ALERT")
                  let alert = UIAlertController(title: "Password Reset", message: "An email was sent to reset your password", preferredStyle: UIAlertController.Style.alert)
                  alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
                  
        }
    }
    
    /*Causes the view (or one of its embedded text fields) to resign the first responder status.*/
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailInput.text, let pwd = passwordInput.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { [weak self] user, error in
                guard self != nil else { return }
                if let user = user {
                    let uid = user.user.uid
                    let userData = ["provider": user.user.providerID]
                    self!.completeSignIn(id: uid, userData: userData)
                } else {
                    let alert = UIAlertController(title: "Email/Password Incorrect", message: "The username/password combination is incorrect. Try again.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self!.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ERIC: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToNewFeed", sender: nil)
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }

}

