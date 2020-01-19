//
//  PostView.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/9/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class PostView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
