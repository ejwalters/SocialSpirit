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
    private var _beverageName: String!
    private var _imageUrl: String!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    private var _beverageType: String!
    private var _beverageRating: Double!
    private var _beverageCategory: String!
    private var _beveragePrice: String!
    private var _wineVintage: String!
    
    var beverageName: String {
        return _beverageName
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postKey: String {
        return _postKey
    }
    
    var beverageType: String {
        return _beverageType
    }
    
    var beverageRating: Double {
        return _beverageRating
    }
    
    var beverageCategory: String {
        return _beverageCategory
    }
    
    var beveragePrice: String {
        return _beveragePrice
    }
    
    var wineVintage: String {
        return _wineVintage
    }
    
    init(beverageName: String, imageUrl: String, beverageRating: Double, beverageType: String, beverageCategory: String, beveragePrice: String, wineVintage: String) {
        self._beverageName = beverageName
        self._imageUrl = imageUrl
        self._beverageName = beverageName
        self._beverageRating = beverageRating
        self._beverageType = beverageType
        self._beverageCategory = beverageCategory
        self._beveragePrice = beveragePrice
        self._wineVintage = wineVintage
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let beverageName = postData["beverageName"] as? String {
            self._beverageName = beverageName
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let beverageType = postData["beverageType"] as? String {
            self._beverageType = beverageType
        }
        
        if let beverageRating = postData["beverageRating"] as? Double {
            self._beverageRating = beverageRating
        }
        if let beverageCategory = postData["beverageCategory"] as? String {
            self._beverageCategory = beverageCategory
        }
        if let beveragePrice = postData["beveragePrice"] as? String {
            self._beveragePrice = beveragePrice
        }
        if let wineVintage = postData["wineVintage"] as? String {
            self._wineVintage = wineVintage
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    
}
