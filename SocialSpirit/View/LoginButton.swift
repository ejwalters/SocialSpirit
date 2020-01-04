//
//  LoginButton.swift
//  SocialSpirit
//
//  Created by Eric Walters on 6/20/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import SwiftyButton

class LoginButton: FlatButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        layer.cornerRadius = 2.0
        
    }

}
