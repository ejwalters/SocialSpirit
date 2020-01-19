//
//  RegisterViewController.swift
//  Spirit-App
//
//  Created by Eric Walters on 1/2/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder
import SwiftKeychainWrapper

@available(iOS 13.0, *)
class RegisterViewController: UIViewController {

 
    @IBOutlet weak var signUpButton: AddButton!
    @IBOutlet weak var firstNameTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var lastNameTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var emailTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var confirmPasswordTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordMatchWarning: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //isModalInPresentation = true
        
        signUpButton.imageView?.contentMode = .scaleAspectFit
        signUpButton.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //Check that passwords match
        if passwordTextField.text == confirmPasswordTextField.text {
            //Passwords match, create user
            print("password match!")
            if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let emailAddress = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                       
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    if error != nil {
                        print("ERIC: Unable to authenticate with Firebase using email")
                        let alert = UIAlertController(title: "Error", message: "There was an error creating your account. Verify that you do not already have an account with the email provided.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(error!)
                    }
                    else {
                        let cleanPassword = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if isPasswordValid(cleanPassword) == false {
                            print("Password does not meet the requirements! Please revise.")
                            return
                        } else {
                            
                            //Create cleaned versions of data
                           
                            print("ERIC: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.user.providerID]
                                let uid = user.user.uid
                                self.completeSignIn(id: uid, userData: userData)
                                let db = Firestore.firestore()
                            db.collection("users").document("\(uid)").setData(["lastname":lastName,"firstname":firstName,"email":emailAddress,"uid":uid])

                            }
                        }
                        
                    }
                }
            
            }
            
        } else {
            passwordMatchWarning.text = "Passwords must match!"
        }
        //Create the user
        
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        //let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ERIC: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    @IBAction func confirmPasswordEditingChanged(_ sender: Any) {
        if passwordTextField.text == confirmPasswordTextField.text {
            passwordMatchWarning.text = ""
        }
     }
    

}
