//
//  User.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/12/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // Properties
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    // Constructor
    init(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let urlString = profileUrlString {
            profileUrl = URL(string: urlString)
        }
        
        tagline = dictionary["description"] as? String
    }

}
