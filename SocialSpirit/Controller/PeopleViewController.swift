//
//  PeopleViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 2/8/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userTableView: UITableView!
    var users = [User]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    let db = Firestore.firestore()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        observeUsers()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        print("USER PROFILE IMAGE - \(user.profileImageUrl)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell {
            if let img = PeopleViewController.imageCache.object(forKey: user.profileImageUrl as NSString) {
                cell.configureCell(user: user, img: img)
            } else {
                cell.configureCell(user: user)
            }
            return cell
        } else {
            return UserCell()
        }
    }
    
    func observeUsers () {

        let nextUser = DataService.ds.REF_USERS
        
        let dbUsers = db.collection("users").document()
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("DB USER -- \(document.documentID) => \(document.data())")
                    //let user = User(userUid: document.documentID, userData: document.data() as Dictionary<String, AnyObject>)
                    let profileImage = document.get("profileImage")!
                    let firstname = document.get("firstname")!
                    let lastname = document.get("lastname")!
                    let email = document.get("email")!
                    let uid = document.get("uid")
                    let user = User(firstname: firstname as! String, lastname: lastname as! String, profileImageUrl: profileImage as! String, userUid: uid as! String, userEmail: email as! String)
                    print("USER --- \(user)")
                    self.users.append(user)
                }
                self.userTableView.reloadData()
            }
        }
        
        //print("USERS ARRAY -- \(users)")
        
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


