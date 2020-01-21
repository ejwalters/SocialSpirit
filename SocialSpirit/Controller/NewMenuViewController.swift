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
    @IBOutlet weak var beerCount: UILabel!
    @IBOutlet weak var wineCount: UILabel!
    @IBOutlet weak var liquorCount: UILabel!
    
    var beerCountArray = [Any]()
    var wineCountArray = [Any]()
    var liquorCountArray = [Any]()
    
    @IBOutlet weak var profileImage: ProfileImage!
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerCountArray.removeAll()
        wineCountArray.removeAll()
        liquorCountArray.removeAll()
        
        myFirebaseNetworkDataRequest {

            //print("BEER ARRAY - \(self.beerCountArray.count)")
            self.beerCount.text = String(self.beerCountArray.count)
            self.liquorCount.text = String(self.liquorCountArray.count)
            self.wineCount.text = String(self.wineCountArray.count)
        }
        
        
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
    
    
    func myFirebaseNetworkDataRequest(finished: @escaping () -> Void) { // the function thats going to take a little moment
        beerCountArray.removeAll()
        wineCountArray.removeAll()
        liquorCountArray.removeAll()
        
        print("BEER ARRAY \(beerCountArray.count)")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let newPost = DataService.ds.REF_USERS.child("\(uid)").child("posts")
         
        newPost.observe(.value, with: { (snapshot) in
             if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                 //print("SNAPSHOT - \(snapshot)")
                 for snap in snapshot {
                     let postData = DataService.ds.REF_POSTS.child(snap.key)
                     //print("SNAP KEY - \(snap.key)")
                     let bevCat = DataService.ds.REF_POSTS.child(snap.key).child("beverageCategory")
                     //print("BEV CAT - \(bevCat)")
                     postData.observe(.value, with: { (snapshot) in
                         if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                             let key = snapshot.key
                             let post = Post(postKey: key, postData: postDict)
                             //print("POST DICT - \(String(describing: postDict["beverageCategory"]!))")
                            if postDict["beverageCategory"]! as! String == "Beer" {
                                self.beerCountArray.append(1)
                                //print("BEER ARRAY LOOP - \(self.beerCountArray)")
                             }
                            if postDict["beverageCategory"]! as! String == "Wine"{
                                self.wineCountArray.append(1)
                             }
                            if postDict["beverageCategory"]! as! String == "Liquor" {
                                self.liquorCountArray.append(1)
                            }
                             //self.posts.append(post)
                         }
                         finished()
                     })
                 }
             }
             
         })

    }
    

}
