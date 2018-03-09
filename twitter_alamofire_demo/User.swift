//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var screenName: String?
    var profilePictureURL: URL
    var coverPictureUrl: URL
    
    var followersCount: Int
    var followingCount: Int
    var numberOfTweets: Int
    // For user persistance
    var dictionary: [String: Any]?
    var description: String

    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    init(dictionary: [String: Any]) {
        numberOfTweets = dictionary["statuses_count"] as! Int
        //print(numberOfTweets)
        name = dictionary["name"] as? String
        screenName = "@" + (dictionary["screen_name"] as! String)
        profilePictureURL = URL(string:dictionary["profile_image_url_https"] as! String)!
    

        if dictionary["profile_banner_url"] != nil  {
            coverPictureUrl = URL(string:dictionary["profile_banner_url"] as! String)!
        }else{
            coverPictureUrl = URL(string:"nil")!
        }
        followersCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        description = dictionary["description"] as! String
        self.dictionary = dictionary
    }
}
