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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isFollowing = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User, img: UIImage? = nil) {
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
            followButton.backgroundColor = .green
            followButton.setTitle("Following", for: .normal)
            isFollowing = true
        } else {
            followButton.backgroundColor = THEME_COLOR
            followButton.setTitle("Follow", for: .normal)
            isFollowing = false
        }

        
    }

}

