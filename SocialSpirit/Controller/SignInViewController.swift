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

class SignInViewController: UIViewController {

    @IBOutlet weak var emailInput: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordInput: TextFieldFloatingPlaceholder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("ERIC: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
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

