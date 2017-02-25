//
//  Tweet.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/12/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    // Properties
    var name: String?
//    var user: User?
    var ownerHandle: String?
    var ownerAvatarURL: URL?
    var text: String?
    var timestamp: Date?
    var retweet_count: Int = 0
    var favorites_count: Int = 0
    var isFavorited: Bool?
    var isRetweeted: Bool?
    var id: Int?
    
    // Constructor
    init(dictionary: NSDictionary) {
        
        print(dictionary)
        
        // initialize properties
        text = dictionary["text"] as? String
        
        isFavorited = dictionary["favorited"] as? Bool
        isRetweeted = dictionary["retweeted"] as? Bool
        
        id = dictionary["id"] as? Int
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favorites_count = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        let userData = dictionary["user"] as! NSDictionary
        let user = User(dictionary: userData)
        name = user.name
        ownerHandle = user.screenname
        ownerAvatarURL = user.profileUrl
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        return dictionaries.map({ (dict) -> Tweet in
            Tweet(dictionary: dict) // convert every element in NSDictionary to a tweet
        })
        
    }
    
    func format(timestamp: Date?) -> String {
        
        if let timestamp = timestamp {
            
            // assume time will always be negative
            let timePassed = -1 * timestamp.timeIntervalSinceNow
            
            // if less than a minute has passed
            if (timePassed < 60) {
                return "Just now"
            }
            // if less than an hour has passed
            else if (timePassed < 3600) {
                return "\(Int(timePassed / 60))m"
            }
            // if less than a day has passed
            else if (timePassed < 216000) {
                return "\(Int(timePassed / 3600))h"
            }
            // if less than a week has passed
            else if (timePassed < 1512000) {
                return "\(Int(timePassed / 216000))d"
            }
            // if less than a month has passed
            else if (timePassed < 6048000) {
                return "\(Int(timePassed / 1512000))m"
            } else {
                return "\(Int(timePassed / 6048000))y"
            }
        }
        
        print("timestamp was NIL")
        
        return "NULL"
        
    }
    
    func format(count: Int) -> String {
        
        if count < 1000 {
            return "\(Int(count))"
        } else {
            let newCount = Double(count) / 1000.0
            let myStr = String(format: "%.1fk", newCount)
            
            // NOTE: Debug Code
            // print("count: \(count), new_count: \(newCount), myStr: \(myStr)")
            
            return myStr
        }
        
    }
    
}
