//
//  File.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/8/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import Foundation
import UIKit

class ProfileImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = self.frame.height/2
    }
    
}
