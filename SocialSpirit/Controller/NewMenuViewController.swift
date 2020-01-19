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

@available(iOS 13.0, *)
class NewMenuViewController: UIViewController {

    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var profileImage: ProfileImage!
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if #available(iOS 13.0, *) {
            let borderColor = UIColor.systemGray6
            signOutView.layer.borderColor = borderColor.cgColor
        } else {
            // Fallback on earlier versions
        }
        signOutView.layer.borderWidth = 40
        
        let docRef = self.db.collection("users").document(self.uid!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstNameDisplay = document.get("firstname")! as! String
                let lastNameDisplay = document.get("lastname")! as! String
                self.fullNameLabel.text = firstNameDisplay + " " + lastNameDisplay
                let emailDisplay = document.get("email")! as! String
                self.emailLabel.text = emailDisplay
                let imageUrl = document.get("profileImage")
                if let img = imageUrl as! NSString? {
                    let cachedImage = ProfileViewController.imageCache.object(forKey: img)
                    if cachedImage == nil {
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
                    } else {
                        self.profileImage.image = cachedImage
                    }
                } else {
                    self.profileImage.image = UIImage(named: "camerablack")
                }
                
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
    

}
