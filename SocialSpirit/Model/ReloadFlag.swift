//
//  ReloadFlag.swift
//  SocialSpirit
//
//  Created by Eric Walters on 1/20/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import Foundation

class ReloadFlag {
    private var _doReload: Bool!
    
    var doReload: Bool {
        return _doReload
    }
    
    init(doReload: Bool) {
        self._doReload = doReload
    }
}
