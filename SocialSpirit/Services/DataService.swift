//
//  DataService.swift
//  devslopes-social
//
//  Created by Jess Rascal on 25/07/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    //Creates singleton
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_FIRST_NAME = DB_BASE.child("users").child("firstName")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_FIRST_NAME: DatabaseReference {
        return _REF_FIRST_NAME
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        //let uid = KeychainWrapper.stringForKey(KEY_UID)
        //let uid = KeychainWrapper.set(KEY_UID)
        let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
