//
//  ExpandableView.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/20/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import UIKit

class ExpandableView: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .green
            translatesAutoresizingMaskIntoConstraints = false

        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override var intrinsicContentSize: CGSize {
            return UIView.layoutFittingExpandedSize
        }


}
