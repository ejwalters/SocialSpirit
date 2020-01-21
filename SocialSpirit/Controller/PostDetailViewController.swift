//
//  PostDetailViewController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/9/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

@available(iOS 13.0, *)
class PostDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var beverageRating: CosmosView!
    @IBOutlet weak var beverageType: TextFields!
    @IBOutlet weak var beverageName: TextFields!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var beveragePrice: TextFields!
    @IBOutlet weak var wineVintage: TextFields!
    var reloadData: ReloadFlag!
    var post: Post!
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
            self.postImage.image = img
        }
        
        imagePicker.delegate = self
        
        //post.postKey
        print("POST - \(post.postKey)")
        beverageName.text = post.beverageName
        beverageType.text = post.beverageType
        beveragePrice.text = post.beveragePrice
        let reloadData = 1
        let newUrl = post.imageUrl
        let beverageCategory = post.beverageCategory
        if post.beverageCategory != "Wine" {
            wineVintage.isHidden = true
        }
        
        wineVintage.text = post.wineVintage
        print("POST URL - \(String(describing: post.imageUrl))")
    
        //DataService.ds.REF_POSTS.child(post.postKey).setValue(["beverageName": beverageName.text, "beverageType": beverageType.text, "beveragePrice": beveragePrice.text])
        
        //print("POST TEST - \(postTest)")
        // Do any additional setup after loading the view.
    }
    

    func myFirebaseNetworkDataRequest(finished: @escaping () -> Void) { // the function thats going to take a little moment
        if let imageData = postImage.image!.jpegData(compressionQuality: 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageItem = STORAGE_BASE.child(imgUid)
            //print("STORAGE ID: \(storageItem)")
            
            
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
                        }
                        finished()
                    })
                }
            }
        }

    }
    
    @IBAction func savePostChangesPresses (sender: Any) {
        myFirebaseNetworkDataRequest {
            self.performSegue(withIdentifier: "reloadFeed", sender: nil)
        }
        
    }
    
    func updateFirebase(imgUrl: String) {
        let updatedPost: Dictionary<String, AnyObject> = [
            "beverageName": beverageName.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "beverageType": beverageType.text! as AnyObject,
            "wineVintage": wineVintage.text! as AnyObject,
            "beverageRating": beverageRating.rating as AnyObject,
            "beveragePrice": beveragePrice.text! as AnyObject,
            "beverageCategory": post.beverageCategory as AnyObject
        ]
        DataService.ds.REF_POSTS.child(post.postKey).setValue(updatedPost)
    }
    
    @IBAction func changePostImagePressed(_ sender: Any) {
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            postImage.image = image
            postImage.contentMode = UIView.ContentMode.scaleAspectFill
            imageSelected = true
            //cameraButton.setImage(nil, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "reloadFeed" {
            let destinationViewController = segue.destination as! FeedViewController
            destinationViewController.reloadData = (sender as? ReloadFlag)!
            //print("POST - \(String(describing: sender))")
        }
    }*/

}
