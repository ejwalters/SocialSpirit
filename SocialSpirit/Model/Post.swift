//
//  Post.swift
//  devslopes-social
//
//  Created by Jess Rascal on 25/07/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _wineName: String!
    private var _imageUrl: String!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    private var _varietalName: String!
    private var _wineRating: Double!
    
    var wineName: String {
        return _wineName
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postKey: String {
        return _postKey
    }
    
    var varietalName: String {
        return _varietalName
    }
    
    var wineRating: Double {
        return _wineRating
    }
    
    init(wineName: String, imageUrl: String, likes: Int) {
        self._wineName = wineName
        self._imageUrl = imageUrl
        self._varietalName = varietalName
        self._wineRating = wineRating
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let wineName = postData["wineName"] as? String {
            self._wineName = wineName
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        
        if let varietalName = postData["wineVarietal"] as? String {
            self._varietalName = varietalName
        }
        
        if let wineRating = postData["wineRating"] as? Double {
            self._wineRating = wineRating
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    
}
