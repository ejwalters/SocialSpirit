//
//  ProfileViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/5/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var emailTextField: AddPostTextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImage: ProfileImage!
    @IBOutlet weak var firstNameTextField: AddPostTextField!
    
    @IBOutlet weak var lastNameTextField: AddPostTextField!
    private var userCollection: CollectionReference!
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    var imageSelected = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        //var usersRef = db.collection("users")
        //print("TEST \(usersRef.whereField("uid", isEqualTo: uid))")
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    if document.get("uid") as! String == uid {
                        let firstNameDisplay = document.get("firstname")!
                        let lastNameDisplay = document.get("lastname")!
                        let emailDisplay = document.get("email")!
                        self.firstNameTextField.text = firstNameDisplay as? String
                        self.lastNameTextField.text = lastNameDisplay as? String
                        self.emailTextField.text = emailDisplay as? String
                    }
                }
            }
        }
        
        //userCollection.getDocuments(completion: )
        //var userList = db.collection("users")
       //print("USERS: \(userList)")

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImage.image = image
            profileImage.contentMode = UIView.ContentMode.scaleAspectFill
            imageSelected = true
            
            cameraButton.setImage(nil, for: .normal)
        }
        


        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        print("BUTTON WORKED!")
        imagePicker.allowsEditing = true
        //imagePicker.sourceType = .photoLibrary
        
        let refreshAlert = UIAlertController(title: "Photo Selection", message: "Select Photo Source", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
    

    @IBAction func backToHomePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFeed", sender: self)
    }
    @IBAction func saveChangesPressed(_ sender: PostButton) {
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
