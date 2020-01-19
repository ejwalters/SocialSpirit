//
//  PostButton.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/5/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class PostButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        /*layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        layer.cornerRadius = 10*/
        
        layer.cornerRadius = 5
        
        //layer.shadowOpacity = 0.25
        //layer.shadowRadius = 5
        //layer.shadowOffset = CGSize(width: 0, height: 10)
        
    }

}
