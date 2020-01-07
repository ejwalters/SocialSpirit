//
//  AddPostViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/5/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AddPostViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addPostModalView: UIView!
    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var wineName: AddPostTextField!
    @IBOutlet weak var wineVarietal: AddPostTextField!
    @IBOutlet weak var wineVintage: AddPostTextField!
    
    
        let imagePicker = UIImagePickerController()
        var imageSelected = false

        
        override func viewDidLoad() {
            super.viewDidLoad()
            //postDescription.delegate = self
            //view.backgroundColor = UIColor.clear
            //view.isOpaque = false
            
            addPostModalView.layer.cornerRadius = 15
            cameraButton.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
            imagePicker.delegate = self
            //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
            newPostImage.isUserInteractionEnabled = true
            //newPostImage.addGestureRecognizer(tap)
            //postDescription.text = "Add a caption"
            //postDescription.textColor = UIColor.lightGray
            let keyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.dismissKeyboard))
            view.addGestureRecognizer(keyboardTap)
            // Do any additional setup after loading the view.
        }
        
        /*@objc func imageTapped(tap: UITapGestureRecognizer) {
            print("BUTTON WORKED!")
            //imagePicker.allowsEditing = false
            //imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }*/
        
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
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    //        self.dismiss(animated: true, completion: { () -> Void in
    //        })
    //
    //        print("Image Picker Complete")
    //        newPostImage.image = image
    //        dismiss(animated: true, completion: nil)
    //    }

        @objc func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                newPostImage.image = image
                newPostImage.contentMode = UIView.ContentMode.scaleAspectFill
                newPostImage.layer.cornerRadius = 15
                //newPostImage.clipsToBounds = true
                newPostImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                newPostImage.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
                newPostImage.layer.shadowOpacity = 0.5
                newPostImage.layer.shadowRadius = 20
                newPostImage.layer.shadowOffset = CGSize(width: 0, height: 10)
                imageSelected = true
                cameraButton.setImage(nil, for: .normal)
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func postButtonTapped(_ sender: Any) {
            
            guard let caption = wineName.text, caption != "" else {
                print("ERIC: Caption must be entered")
                return
            }
            
            guard let img = newPostImage.image, imageSelected == true else {
                print("ERIC: An image must be selected")
                return
            }
            
            if let imageData = img.jpegData(compressionQuality: 0.2) {
                
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
                                self.postToFirebase(imgUrl: url!.absoluteString)
                                print("URL for image: \(String(describing: url))")
                            }
                        })
                    }
                }
            }
            performSegue(withIdentifier: "reloadFeed", sender: self)
        }
        
        func postToFirebase(imgUrl: String) {
            let post: Dictionary<String, AnyObject> = [
                "caption": wineName.text! as AnyObject,
                "imageUrl": imgUrl as AnyObject,
                "likes": 0 as AnyObject
            ]
            
            let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
            firebasePost.setValue(post)
            let userPost = firebasePost.key

            print("Firebase Post: \(String(describing: firebasePost))")
            
            
            _ = Auth.auth().addStateDidChangeListener { (auth,user) in
                if let user = user {
                    let userId = user.uid
                    print("USER: \(String(describing: userId))")
                    let newPost = DataService.ds.REF_USERS.child("\(userId)").child("posts").child(userPost!)
                    newPost.setValue(true)
                    
                }
            }
            
            wineName.text = ""
            imageSelected = false
            newPostImage.image = UIImage(named: "icons8-camera-100")

        }
        
        /*func textViewDidBeginEditing(_ postDescription: UITextView) {
            if postDescription.textColor == UIColor.lightGray {
                postDescription.text = nil
                postDescription.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ postDescription: UITextView) {
            if postDescription.text.isEmpty {
                postDescription.text = "Add a caption"
                postDescription.textColor = UIColor.lightGray
            }
        }*/
        
        

        @IBAction func didTapCloseNewPost(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
        

}
