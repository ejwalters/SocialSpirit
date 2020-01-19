//
//  AddButton.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/9/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AddButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = layer.frame.height/2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
