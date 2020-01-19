//
//  TextFields.swift
//  SocialSpirit
//
//  Created by Eric Walters on 6/21/19.
//  Copyright © 2019 Eric Walters. All rights reserved.
//

import UIKit
import TextFieldFloatingPlaceholder

@available(iOS 13.0, *)
class TextFields: TextFieldFloatingPlaceholder {

    override func awakeFromNib() {
        super.awakeFromNib()
        super.floatingPlaceholderColor = UIColor.systemGray6
        super.validationFalseLineEditingColor = UIColor.systemGray6
        super.validationTrueLineEditingColor = UIColor.systemGray6
        super.validationFalseLineColor = UIColor.systemGray6
        super.validationTrueLineColor = UIColor.systemGray6
        // Initialization code
    }

}
