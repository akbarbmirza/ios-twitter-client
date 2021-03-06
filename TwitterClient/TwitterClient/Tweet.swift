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
    var retweetText: String?
    var timestamp: Date?
    var retweet_count: Int = 0
    var favorites_count: Int = 0
    var isFavorited: Bool?
    var isRetweetStatus: Bool
    var isRetweeted: Bool?
    var id: Int?
    var originalTweetID: Int?
    var retweetedBy: String?
    
    // Constructor
    init(dictionary: NSDictionary) {
        
        // NOTE: DEBUG CODE
        // print(dictionary)
        
        // initialize properties
        text = dictionary["text"] as? String
        retweetText = dictionary["retweet_text"] as? String
        
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favorites_count = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        isFavorited = dictionary["favorited"] as? Bool
        isRetweeted = dictionary["retweeted"] as? Bool
        isRetweetStatus = (dictionary["retweeted_status"] != nil) ? true : false
        
        id = dictionary["id"] as? Int
        
        var userData: NSDictionary = [:]
        
        if isRetweetStatus {
            
            retweetedBy = dictionary.value(forKeyPath: "user.name") as? String
            let retweetedData = dictionary["retweeted_status"] as! NSDictionary
            userData = retweetedData["user"] as! NSDictionary
            originalTweetID = retweetedData["id"] as? Int
        } else {
            originalTweetID = id
            userData = dictionary["user"] as! NSDictionary
            
        }
        
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
        if count < 10000 || count == 0 {
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
