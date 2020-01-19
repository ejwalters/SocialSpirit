//
//  CellView.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/18/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class CellView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 15.0
    }

}
