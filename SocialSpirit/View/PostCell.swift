//
//  PostCell.swift
//  Spirit-App
//
//  Created by Eric Walters on 1/13/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import UIImageColors
import ColorThiefSwift
import Cosmos

@available(iOS 13.0, *)
class PostCell: UITableViewCell {

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var overImageView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingNumber: CosmosView!
    @IBOutlet weak var userRating: UILabel!
    let db = Firestore.firestore()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var post: Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        self.ratingView.layer.cornerRadius = self.ratingView.bounds.height / 2

        
        let docRef = self.db.collection("users").document(post.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let imageUrl = document.get("profileImage")
                //self.userName.text = "\(firstNameDisplay)" + "\(lastNameDisplay)"
                if let img = imageUrl as! NSString? {
                    let cachedImage = PostCell.imageCache.object(forKey: img)
                    if cachedImage == nil {
                        let ref = Storage.storage().reference(forURL: img as String)
                        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("ERIC: Unable to download image from Firebase storage")
                            } else {
                                print("ERIC: Image downloaded from Firebase storage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        PostCell.imageCache.setObject(img, forKey: imageUrl as! NSString)
                                        //self.cameraButton.setImage(nil, for: .normal)
                                        self.postProfileImage.image = img
                                    }
                                }
                            }
                        })
                    } else {
                        //self.cameraButton.setImage(nil, for: .normal)
                        self.postProfileImage.image = cachedImage
                    }
                    
                }
                
                //self.firstNameTextField.text = firstNameDisplay as? String
                //self.lastNameTextField.text = lastNameDisplay as? String
                //self.emailTextField.text = emailDisplay as? String
            } else {
                print("Document does not exist")
            }
        }
        
        self.postDescription.text = post.beverageName
        let intUserRating = Int(post.beverageRating)
        self.userRating.text = String(intUserRating)
        //self.userName.text = post.beverageType
        //self.ratingNumber.rating = post.beverageRating
        postImage.layer.cornerRadius = 15.0
        postImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let postKey = post.postKey
        //let userId = DataService.ds.REF_USERS.child().child("posts").child
        
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("ERIC: Unable to download image from Firebase storage")
                } else {
                    print("ERIC: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
            
        }
        
    }
    
}



