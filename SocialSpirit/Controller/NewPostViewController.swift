//
//  NewPostViewController.swift
//  Spirit-App
//
//  Created by Eric Walters on 2/9/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit

class NewPostViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        imagePicker.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        newPostImage.isUserInteractionEnabled = true
        newPostImage.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        print("BUTTON WORKED!")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        self.dismiss(animated: true, completion: { () -> Void in
//        })
//        
//        print("Image Picker Complete")
//        newPostImage.image = image
//        dismiss(animated: true, completion: nil)
//    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            newPostImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}
