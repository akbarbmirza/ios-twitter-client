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
    var text: String?
    var timestamp: Date?
    var retweet_count: Int = 0
    var favorites_count: Int = 0
    
    // Constructor
    init(dictionary: NSDictionary) {
        // initialize properties
        text = dictionary["text"] as? String
        
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favorites_count = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dict in dictionaries {
            let tweet = Tweet(dictionary: dict)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
