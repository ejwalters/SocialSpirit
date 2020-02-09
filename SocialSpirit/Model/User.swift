//
//  User.swift
//  SocialSpirit
//
//  Created by Eric Walters on 2/8/20.
//  Copyright © 2020 Eric Walters. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    
    private var _firstname: String!
    private var _lastname: String!
    private var _profileImageUrl: String!
    private var _userUid: String!
    private var _userEmail: String!
    private var _userBeerCount: Int!
    private var _userLiquorCount: Int!
    private var _userWineCount: Int!
    
    var firstname: String {
        return _firstname
    }
    
    var lastname: String {
        return _lastname
    }
    
    var profileImageUrl: String {
        return _profileImageUrl
    }
    
    var userUid: String {
        return _userUid
    }
    
    var userEmail: String {
        return _userEmail
    }
    /*
    var userBeerCount: Int {
        return _userBeerCount
    }
    
    var userLiquorCount: Int {
        return _userLiquorCount
    }
    
    var userWineCount: Int {
        return _userWineCount
    }*/
    
    init(firstname: String, lastname: String, profileImageUrl: String, userUid: String, userEmail: String) {
        self._firstname = firstname
        self._lastname = lastname
        self._profileImageUrl = profileImageUrl
        self._userUid = userUid
        self._userEmail = userEmail
        /*
        self._userBeerCount = userBeerCount
        self._userLiquorCount = userLiquorCount
        self._userWineCount = userWineCount*/
        
    }
    
    init(userUid: String, userData: Dictionary<String, AnyObject>) {
        self._userUid = userUid
        
        if let firstname = userData["firstname"] as? String {
            self._firstname = firstname
        }
        
        if let lastname = userData["lastname"] as? String {
            self._lastname = lastname
        }
        
        if let profileImageUrl = userData["profileImage"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        
        if let userEmail = userData["email"] as? String {
            self._userEmail = userEmail
        }
        /*
        if let userBeerCount = userData["beerCount"] as? Int {
            self._userBeerCount = userBeerCount
        }
        if let userLiquorCount = userData["liquorCount"] as? Int {
            self._userLiquorCount = userLiquorCount
        }
        if let userWineCount = userData["wineCount"] as? Int {
            self._userWineCount = userWineCount
        }*/
        
        
        //_postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
}
