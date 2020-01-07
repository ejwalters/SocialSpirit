//
//  AddPostTextField.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/7/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import Foundation
import TextFieldFloatingPlaceholder

class AddPostTextField: TextFieldFloatingPlaceholder {

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13.0, *) {
            super.floatingPlaceholderColor = UIColor.systemGray6
            super.validationFalseLineEditingColor = UIColor.systemGray6
            super.validationTrueLineEditingColor = UIColor.systemGray6
            super.validationFalseLineColor = UIColor.systemGray6
            super.validationTrueLineColor = UIColor.systemGray6
        } else {
            super.floatingPlaceholderColor = UIColor.black
            super.validationFalseLineEditingColor = UIColor.black
            super.validationTrueLineEditingColor = UIColor.black
            super.validationFalseLineColor = UIColor.black
            super.validationTrueLineColor = UIColor.black        }
        // Initialization code
    }

}

