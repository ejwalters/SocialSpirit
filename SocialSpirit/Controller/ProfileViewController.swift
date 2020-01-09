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
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    var imageSelected = false
    let uid = Auth.auth().currentUser?.uid
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
        
        let docRef = self.db.collection("users").document(self.uid!)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let firstNameDisplay = document.get("firstname")!
                        let lastNameDisplay = document.get("lastname")!
                        let emailDisplay = document.get("email")!
                        let imageUrl = document.get("profileImage")
                        let img = imageUrl as! NSString
                        print("IMG -- \(img)")
                        let ref = Storage.storage().reference(forURL: img as String)
                        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("ERIC: Unable to download image from Firebase storage")
                            } else {
                                print("ERIC: Image downloaded from Firebase storage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.cameraButton.setImage(nil, for: .normal)
                                        self.profileImage.image = img
                                    }
                                }
                            }
                        })
                        self.firstNameTextField.text = firstNameDisplay as? String
                        self.lastNameTextField.text = lastNameDisplay as? String
                        self.emailTextField.text = emailDisplay as? String
                    } else {
                        print("Document does not exist")
                    }
                }
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
        
        if let imageData = profileImage.image!.jpegData(compressionQuality: 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageItem = STORAGE_BASE.child(imgUid)
            print("STORAGE ID: \(storageItem)")
            
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("ERIC: Unable to upload image to Firebasee torage")
                } else {
                    print("ERIC: Successfully uploaded image to Firebase storage")
                    DataService.ds.REF_POST_IMAGES.child(imgUid).downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("ERROR in image \(error!)")
                            print("Error URL for image: \(String(describing: url))")
                            return
                        }
                        if url != nil {
                            self.updateFirebase(imgUrl: url!.absoluteString)
                            print("URL for image: \(String(describing: url))")
                        }
                    })
                }
            }
        }
        performSegue(withIdentifier: "goToFeed", sender: self)
    }
    
    func updateFirebase(imgUrl: String) {

        db.collection("users").document(uid!).setData([ "firstname": firstNameTextField.text!, "lastname": lastNameTextField.text!, "email": emailTextField.text!, "profileImage": imgUrl], merge: true)

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
