//
//  UserCell.swift
//  SocialSpirit
//
//  Created by Eric Walters on 2/8/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var isFollowing: Bool!
    
    let db = Firestore.firestore()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var user: User!
    let uid = Auth.auth().currentUser?.uid
    var follows = [String]()
    //getCurrentUserFollowers()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //getCurrentUserFollowers()
        //isFollowing = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User, img: UIImage? = nil) {
           
        print("FOLLOWS ARRAY - \(follows)")
        //Check if current user is already following the user in this cell
        //let currentUserFollowers = DataService.ds.REF_USERS.child("\(uid!)").child("follows")
        //print("CURRENT USER FOLLOWER - \(currentUserFollowers)")
        let currentUserFollowers = DataService.ds.REF_USERS.child("\(uid!)").child("follows")
        
        
        currentUserFollowers.observe(.value, with: { (snapshot) in
                   self.follows = []
                   if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                       for snap in snapshot {
                        print("SNAP USER - \(snap.key)")
                        if snap.key == user.userUid {
                            self.followButton.backgroundColor = .green
                            self.followButton.setTitle("Following", for: .normal)
                            self.isFollowing = true
                        }
                       }
                   }
                   
               })
        
        //print("USER \(uid!) FOLLOWS \(currentUserFollowers)")
        
        self.user = user
           
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.bounds.height / 2

           
        let docRef = self.db.collection("users").document(user.userUid)
           docRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   let imageUrl = document.get("profileImage")
                   //self.userName.text = "\(firstNameDisplay)" + "\(lastNameDisplay)"
                   if let img = imageUrl as! NSString? {
                       let cachedImage = UserCell.imageCache.object(forKey: img)
                       if cachedImage == nil {
                           let ref = Storage.storage().reference(forURL: img as String)
                           ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                               if error != nil {
                                   print("ERIC: Unable to download image from Firebase storage")
                               } else {
                                   print("ERIC: Image downloaded from Firebase storage")
                                   if let imgData = data {
                                       if let img = UIImage(data: imgData) {
                                           UserCell.imageCache.setObject(img, forKey: imageUrl as! NSString)
                                           //self.cameraButton.setImage(nil, for: .normal)
                                           self.userProfileImage.image = img
                                       }
                                   }
                               }
                           })
                       } else {
                           //self.cameraButton.setImage(nil, for: .normal)
                           self.userProfileImage.image = cachedImage
                       }
                       
                   }
                   
                   //self.firstNameTextField.text = firstNameDisplay as? String
                   //self.lastNameTextField.text = lastNameDisplay as? String
                   //self.emailTextField.text = emailDisplay as? String
               } else {
                   print("Document does not exist")
               }
           }
           
        self.userName.text = user.firstname + " " + user.lastname
           
       }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        if isFollowing != true {
            //Add the user id to the current user's follows list
            DataService.ds.REF_USERS.child("\(uid!)").child("follows").child("\(user.userUid)").setValue(true)
            //Add the all of the user's posts the current user's timeline
            observePosts()
            followButton.backgroundColor = .green
            followButton.setTitle("Following", for: .normal)
            isFollowing = true
        } else {
            //Remove the user id from the current user's follows list
            DataService.ds.REF_USERS.child("\(uid!)").child("follows").child("\(user.userUid)").removeValue()
            removeTimelinePosts()
            followButton.backgroundColor = THEME_COLOR
            followButton.setTitle("Follow", for: .normal)
            isFollowing = false
        }

        
    }
    
    /*func getCurrentUserFollowers () {
        
        let currentUserFollowers = DataService.ds.REF_USERS.child("\(uid!)").child("follows")
        
        
        currentUserFollowers.observe(.value, with: { (snapshot) in
                   self.follows = []
                   if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                       for snap in snapshot {
                        print("SNAP USER - \(snap.key)")
                        self.follows.append(snap.key)
                        print("SELF FOLLOWS - \(self.follows)")
                           //let postData = DataService.ds.REF_POSTS.child(snap.key)
                           /*postData.observe(.value, with: { (snapshot) in
                               if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                                   let key = snapshot.key
                                   let post = Post(postKey: key, postData: postDict)
                                   //self.posts.append(post)
                               }
                               //self.feedTableView.reloadData()
                           })*/
                       }
                   }
                   
               })
    }*/
    
    func observePosts() {
        let newPost = DataService.ds.REF_USERS.child("\(user.userUid)").child("posts")
        newPost.observe(.value, with: { (snapshot) in
                   //self.posts = []
                   if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                       for snap in snapshot {
                           let postData = DataService.ds.REF_POSTS.child(snap.key)
                           postData.observe(.value, with: { (snapshot) in
                               if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                                    let key = snapshot.key
                                    DataService.ds.REF_TIMELINE.child("\(self.uid!)").child("\(key)").setValue(true)
                                   //let post = Post(postKey: key, postData: postDict)
                                   //self.posts.append(post)
                               }
                               //self.feedTableView.reloadData()
                           })
                       }
                   }
                   
               })
    }
    
    func removeTimelinePosts() {
        let newPost = DataService.ds.REF_USERS.child("\(user.userUid)").child("posts")
        newPost.observe(.value, with: { (snapshot) in
                   //self.posts = []
                   if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                       for snap in snapshot {
                           let postData = DataService.ds.REF_POSTS.child(snap.key)
                           postData.observe(.value, with: { (snapshot) in
                               if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                                    let key = snapshot.key
                                    DataService.ds.REF_TIMELINE.child("\(self.uid!)").child("\(key)").removeValue()
                                   //let post = Post(postKey: key, postData: postDict)
                                   //self.posts.append(post)
                               }
                               //self.feedTableView.reloadData()
                           })
                       }
                   }
                   
               })
    }

}

