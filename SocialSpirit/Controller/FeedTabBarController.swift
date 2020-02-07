//
//  FeedTabBarController.swift
//  SocialSpirit
//
//  Created by Eric Walters on 2/6/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class FeedTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
                  isModalInPresentation = true
              } else {
                  // Fallback on earlier versions
                }
        
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
