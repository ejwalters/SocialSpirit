//
//  FeedViewController.swift
//  Spirit-App
//
//  Created by Eric Walters on 1/2/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import JJFloatingActionButton
import MaterialComponents.MaterialCards
import UIImageColors
import ColorThiefSwift
import Floaty

@available(iOS 13.0, *)
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var floatingButton: Floaty!
    
    let transition = SlideInTransition()
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var leftConstraint: NSLayoutConstraint!
    //var reloadData : ReloadFlag?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        

        configureFloatingButtons()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let newPost = DataService.ds.REF_USERS.child("\(uid)").child("posts")
        
        newPost.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let postData = DataService.ds.REF_POSTS.child(snap.key)
                    postData.observe(.value, with: { (snapshot) in
                        if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                            let key = snapshot.key
                            let post = Post(postKey: key, postData: postDict)
                            self.posts.append(post)
                        }
                        self.feedTableView.reloadData()
                    })
                }
            }
            
        })
        

        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    


    @IBAction func didTapMenu(_ sender: UIButton) {
            guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "NewMenuViewController") else {return}
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            present(menuViewController, animated: true)
            let tap = UITapGestureRecognizer(target: self, action:    #selector(self.handleTap(_:)))
               transition.dimmingView.addGestureRecognizer(tap)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("TEST")
            print("INDEX - \(indexPath.row)")
            let post = posts[indexPath.row]
            self.performSegue(withIdentifier: "toPostDetail", sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toPostDetail" {
            let destinationViewController = segue.destination as! PostDetailViewController
            destinationViewController.post = sender as? Post
            print("POST - \(String(describing: sender))")
        }
        if segue.identifier == "goToAddNewPost" {
            let destinationViewController = segue.destination as! AddPostViewController
            destinationViewController.post = sender as? Post
        }
    }
    
    func configureFloatingButtons() {
        floatingButton.addItem("Wine", icon: UIImage(named: "whitewinebottle")!, handler: { _ in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Wine", beveragePrice: "", wineVintage: "")
            print("NEW POST \(newPost)")
            self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
            
        })
        floatingButton.addItem("Beer", icon: UIImage(named: "whitebeer")!, handler: { _ in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Beer", beveragePrice: "", wineVintage: "")
            print("NEW POST \(newPost)")
            self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
        })
        floatingButton.addItem("Liquor", icon: UIImage(named: "whiteliquor")!, handler: { _ in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Liquor", beveragePrice: "", wineVintage: "")
            print("NEW POST \(newPost)")
            self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
        })
    }
    

    
}

@available(iOS 13.0, *)
extension FeedViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}


