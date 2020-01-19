//
//  PostDetailViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/9/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    var post: Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
            self.postImage.image = img
        }
        print("POST URL - \(String(describing: post.imageUrl))")
    

        // Do any additional setup after loading the view.
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
