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

    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
//        feedTableView.backgroundView = UIImageView(image: UIImage(named: "SpiritLoginImage"))
        
        
        //feedTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        feedTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "customPostCell")
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPostCell", for: indexPath) as! PostCell
        let messageArray = ["skfajgsdfjkg", "Second Message", "Third Message","asdkjfadsdsaghj","adsjfhgsadhjk","sdfjkhasdk"]
        
        //cell.messageBody.text = messageArray[indexPath.row]
        cell.postDescription.text = messageArray[indexPath.row]
        print("INDEX PATH = \(indexPath)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func configureTableView() {
        //feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 120.0
    }
    
    
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
