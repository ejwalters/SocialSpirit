//
//  TextFields.swift
//  SocialSpirit
//
//  Created by Eric Walters on 6/21/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import TextFieldFloatingPlaceholder

class TextFields: TextFieldFloatingPlaceholder {

    override func awakeFromNib() {
        super.awakeFromNib()
        super.floatingPlaceholderColor = UIColor.white
        super.validationFalseLineEditingColor = UIColor.white
        super.validationTrueLineEditingColor = UIColor.white
        super.validationFalseLineColor = UIColor.white
        super.validationTrueLineColor = UIColor.white
        // Initialization code
    }

}
