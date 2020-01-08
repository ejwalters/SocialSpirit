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

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var lastNameTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var emailTextField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordTextField: TextFieldFloatingPlaceholder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //Create the user
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailAddress = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                   
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if error != nil {
                    print("ERIC: Unable to authenticate with Firebase using email")
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
                            db.collection("users").addDocument(data: ["lastname":lastName,"firstname":firstName,"email":emailAddress,"uid":uid]) { (error) in
                                if error != nil {
                                    print(error!)
                                }
                            }
                        }
                    }
                    
                }
            }
        
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        //let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("ERIC: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    

}
