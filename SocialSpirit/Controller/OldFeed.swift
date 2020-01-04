//
//  OldFeed.swift
//  SocialSpirit
//
//  Created by Eric Walters on 7/2/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

/*import Foundation


//
//  FeedViewController.swift
//  Spirit-App
//
//  Created by Eric Walters on 1/2/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //@IBOutlet weak var feedTableView2: UITableView!
    @IBOutlet weak var feedTableView: UITableView!
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        //        feedTableView.backgroundView = UIImageView(image: UIImage(named: "SpiritLoginImage"))
        
        /*
         guard let uid = Auth.auth().currentUser?.uid else {
         return
         }
         print("USER ID: \(uid)")
         let newPost = DataService.ds.REF_USERS.child("\(uid)").child("posts")
         
         newPost.observe(.value, with: { (snapshot) in
         self.posts = []
         if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
         for snap in snapshot {
         //print("ERIC SNAP: \(String(describing: snap.key))")
         let postData = DataService.ds.REF_POSTS.child(snap.key)
         print("SNAP: \(snap)")
         postData.observe(.value, with: { (snapshot) in
         self.posts = []
         print("DATA KEY: \(snap.key)")
         print("DATA VALUE: \(String(describing: snapshot))")
         if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
         let key = snapshot.key
         let post = Post(postKey: key, postData: postDict)
         self.posts.append(post)
         print("POST: \(post)")
         }
         
         //self.feedTableView.reloadData()
         
         })
         }
         }
         self.feedTableView.reloadData()
         })*/
        
        
        _ = Auth.auth().addStateDidChangeListener { (auth,user) in
            if let user = user {
                let userId = user.uid
                //print("USER: \(String(describing: userId))")
                let newPost = DataService.ds.REF_USERS.child("\(userId)").child("posts")
                print("NEW POST: \(newPost)")
                newPost.observe(.value, with: { (snapshot) in
                    self.posts = []
                    if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshot {
                            //print("ERIC SNAP: \(String(describing: snap.key))")
                            let postData = DataService.ds.REF_POSTS.child(snap.key)
                            postData.observe(.value, with: { (snapshot) in
                                self.posts = []
                                print("DATA KEY: \(snapshot.key)")
                                print("SNAP VALUE: \(String(describing: snap))")
                                if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                                    let key = snapshot.key
                                    let post = Post(postKey: key, postData: postDict)
                                    self.posts.append(post)
                                    print("POST: \(post)")
                                }
                                
                                //self.feedTableView.reloadData()
                                
                            })
                        }
                    }
                    //self.feedTableView.reloadData()
                })
                
            }
        }
        
        self.feedTableView.reloadData()
        
        
        
        
        /*
         DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
         self.posts = []
         if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
         for snap in snapshot {
         print("SNAP: \(snap)")
         if let postDict = snap.value as? Dictionary<String, AnyObject> {
         let key = snap.key
         let post = Post(postKey: key, postData: postDict)
         self.posts.append(post)
         print("POST: \(self.posts)")
         }
         }
         }
         self.feedTableView.reloadData()
         })*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        print("POSTS: \(posts[indexPath.row])")
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell{
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func configureTableView() {
     feedTableView.estimatedRowHeight = 120.0
     }*/
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToSignIn", sender: self)
        }
        catch {
            print("Error, there was a problem signing out.")
        }
        
    }
    
    @IBAction func addNewPost(_ sender: Any) {
        
        let modalViewController = NewPostViewController()
        modalViewController.modalPresentationStyle = .overFullScreen
        present(modalViewController, animated: true, completion: nil)
        print("MODAL CLICKED")
        
    }
    
}
*/
