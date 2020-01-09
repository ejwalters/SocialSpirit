//
//  NewMenuViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/8/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class NewMenuViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var profileImage: ProfileImage!
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docRef = self.db.collection("users").document(self.uid!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstNameDisplay = document.get("firstname")! as! String
                let lastNameDisplay = document.get("lastname")! as! String
                self.fullNameLabel.text = firstNameDisplay + " " + lastNameDisplay
                let emailDisplay = document.get("email")! as! String
                self.emailLabel.text = emailDisplay
                let imageUrl = document.get("profileImage")
                let img = imageUrl as! NSString
                print("IMG -- \(img)")
                let ref = Storage.storage().reference(forURL: img as String)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ERIC: Unable to download image from Firebase storage")
                    } else {
                        print("ERIC: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                            }
                        }
                    }
                })
                //self.firstNameTextField.text = firstNameDisplay as? String
                //self.lastNameTextField.text = lastNameDisplay as? String
                //self.emailTextField.text = emailDisplay as? String
            } else {
                print("Document does not exist")
            }
        }
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        profileImage.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let _: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            performSegue(withIdentifier: "goToSignIn", sender: self)
        }
        catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
