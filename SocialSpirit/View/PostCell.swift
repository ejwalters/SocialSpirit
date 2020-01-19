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

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var overImageView: UIView!
    @IBOutlet weak var varietalName: UILabel!
    @IBOutlet weak var ratingNumber: CosmosView!
    
    var post: Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        self.postDescription.text = post.wineName
        self.varietalName.text = post.varietalName
        self.ratingNumber.rating = post.wineRating
        postImage.layer.cornerRadius = 15.0
        postImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //postImage.addSubview(redBox)
        //postImage.layer.cornerRadius = 25.0
        /*postImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView!.addGestureRecognizer(tapRecognizer)*/
        
        //ColorThief.getColor(from: img!)
        /*DispatchQueue.main.async {
            self.overImageView.backgroundColor = ColorThief.getColor(from: img!)?.makeUIColor()
        }*/
        
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



