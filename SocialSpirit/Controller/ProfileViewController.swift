//
//  ProfileViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/5/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    private var userCollection: CollectionReference!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        var usersRef = db.collection("users")
        print("TEST \(usersRef.whereField("uid", isEqualTo: uid))")
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.get("uid") as! String == uid {
                        let firstNameDisplay = document.get("firstname")!
                        let lastNameDisplay = document.get("lastname")!
                        self.firstName.text = firstNameDisplay as? String
                        self.lastName.text = lastNameDisplay as? String
                    }
                }
            }
        }
        
        //userCollection.getDocuments(completion: )
        var userList = db.collection("users")
        print("USERS: \(userList)")
        //var docUser = userList.document("lI4JLyK5wcy2Fr3CZluG")
        /*docUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }*/
        //print("THE DOC LIST: \(docUser)")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backToHomePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFeed", sender: self)
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
