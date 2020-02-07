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
    @IBOutlet weak var currentUserProfileImage: ProfileImage!
    
    let transition = SlideInTransition()
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    static var userProfileImageCache: NSCache<NSString, UIImage> = NSCache()
    var leftConstraint: NSLayoutConstraint!
    
    let uid = Auth.auth().currentUser?.uid
    //var reloadData : ReloadFlag?
    
    //let actionButton = JJFloatingActionButton()
    
    var beerCount: Int!
    var wineCount: Int!
    var liquorCount: Int!
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        

        //configureFloatingButtons()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let newPost = DataService.ds.REF_USERS.child("\(uid)").child("posts")
        
        getCurrentUserProfilePicture()
        observeTimelinePosts()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        currentUserProfileImage.addGestureRecognizer(tap)
        //observePosts()

        /*
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
            
        })*/
        
    }
    
    func observeTimelinePosts () {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newPost = DataService.ds.REF_TIMELINE.child("\(uid)")
        
        print("NEW POST - \(newPost)")
        
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
    
    
    func observePosts () {
        
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
    
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("INDEX OF POST ARRAY - \(indexPath.row)")
        print("POSTS: \(posts[indexPath.row])") //Index out of range error here
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if (editingStyle == .delete) {
            let post = posts[indexPath.row]
            DataService.ds.REF_USERS.child("\(uid!)").child("posts").child("\(post.postKey)").removeValue()
            DataService.ds.REF_POSTS.child("\(post.postKey)").removeValue()
            let docRef = self.db.collection("users").document(self.uid!)
                print("DOC REF - \(docRef)")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    print("DOC - \(document)")
                    self.beerCount = document.get("beerCount")! as? Int
                    self.wineCount = document.get("wineCount")! as? Int
                    self.liquorCount = document.get("liquorCount")! as? Int
                
                    if post.beverageCategory == "Wine" {
                        self.wineCount -= 1
                        self.db.collection("users").document(self.uid!).setData([ "wineCount": self.wineCount!], merge: true)
                    }
                
                    if post.beverageCategory == "Beer" {
                        self.beerCount = self.beerCount - 1
                        self.db.collection("users").document(self.uid!).setData([ "beerCount": self.beerCount!], merge: true)
                    }
                
                    if post.beverageCategory == "Liquor" {
                        self.liquorCount -= 1
                        self.db.collection("users").document(self.uid!).setData([ "liquorCount": self.liquorCount!], merge: true)
                    }
                
                print("BEER - \(String(describing: self.beerCount!)) - LIQUOR - \(String(describing: self.liquorCount!)) - WINE - \(String(describing: self.wineCount!))")
            } else {
                print("Document does not exist")
            }
        }
           //ref.remove()
           //remove the row from the dataSource
           //reload the tableView
       }
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
    
    func getCurrentUserProfilePicture() {
        let docRef = self.db.collection("users").document(self.uid!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let imageUrl = document.get("profileImage")
                if let img = imageUrl as! NSString? {
                    let cachedImage = FeedViewController.userProfileImageCache.object(forKey: img)
                    if cachedImage == nil {
                        print("IMAGE NIL!")
                        let ref = Storage.storage().reference(forURL: img as String)
                        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("ERIC: Unable to download image from Firebase storage")
                            } else {
                                print("ERIC: Image downloaded from Firebase storage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        NewMenuViewController.imageCache.setObject(img, forKey: imageUrl as! NSString)
                                        self.currentUserProfileImage.image = img
                                    }
                                }
                            }
                        })
                    } else {
                        print("IMAGE CACHED!")
                        self.currentUserProfileImage.image = cachedImage
                    }
                } else {
                    self.currentUserProfileImage.image = UIImage(named: "camerablack")
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    /*func configureFloatingButtons() {
        let themeColor = hexStringToUIColor(hex: "EFDCD5")
        actionButton.buttonColor = themeColor
        actionButton.buttonImageColor = .black
        actionButton.addItem(title: "Wine", image: UIImage(named: "whitewinebottle")?.withRenderingMode(.alwaysTemplate)) { item in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Wine", beveragePrice: "", wineVintage: "", uid: self.uid!, postTimeStamp: 0.0)
          print("NEW POST \(newPost)")
          self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
        }
        
        actionButton.addItem(title: "Beer", image: UIImage(named: "whitebeer")?.withRenderingMode(.alwaysTemplate)) { item in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Beer", beveragePrice: "", wineVintage: "", uid: self.uid!, postTimeStamp: 0.0)
            print("NEW POST \(newPost)")
            self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
        }
        
        actionButton.addItem(title: "Liquor", image: UIImage(named: "whiteliquor")?.withRenderingMode(.alwaysTemplate)) { item in
            let newPost = Post(beverageName: "", imageUrl: "", beverageRating: 0.0, beverageType: "", beverageCategory: "Liquor", beveragePrice: "", wineVintage: "", uid: self.uid!, postTimeStamp: 0.0)
            print("NEW POST \(newPost)")
            self.performSegue(withIdentifier: "goToAddNewPost", sender: newPost)
        }
        
        actionButton.configureDefaultItem { item in
            //item.titlePosition = .trailing

            item.buttonColor = themeColor
            item.buttonImageColor = .black

        }
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }*/
    

    
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

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



