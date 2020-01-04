//
//  Helpers.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/3/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import Foundation


//Add Password Validation

func isPasswordValid(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}
