//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var id: String!
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var bio: String?
    var tweetCount: Int!
    var followingCount: Int!
    var followersCount: Int!
    var dictionary: [String: Any]?
    
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
        id = dictionary["id_str"] as! String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileUrl = URL(string: dictionary["profile_image_url_https"] as! String)
        bio = dictionary["description"] as? String
        tweetCount = dictionary["statuses_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        self.dictionary = dictionary
    }
}
