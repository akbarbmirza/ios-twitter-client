//
//  User.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/12/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // Stored Properties
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    // serialize user data back into JSON for persistence
    var dictionary: NSDictionary?
    
    // Constructor
    init(dictionary: NSDictionary) {
        
        // initialize our dictionary property with our original dictionary
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        } else {
            profileUrl = URL(string: "")
        }
    }
    
    static let userDidLogoutNotification = Notification.Name("UserDidLogout")
    
    static var _currentUser : User?
    
    // create a class variable
    // this will be a computed property
    class var currentUser: User? {
        
        // what to do when I access currentUser in code
        get {
            
            // NOTE: check this
            if _currentUser == nil {
                // load UserDefaults
                let defaults = UserDefaults.standard
                
                // load data in currentUser to our user variable
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                // safely unwrap userData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            // return that user
            return _currentUser
        }
        
        set(user) {
            
            // set currentUser to user
            _currentUser = user
            
            // load UserDefaults
            let defaults = UserDefaults.standard
            
            // if our user is not nil
            if let user = user {
                // serialize our dictionary and set it to our data
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                // set our data
                defaults.set(data, forKey: "currentUserData")
            } else {
                // set nil to say that we don't have a user
                defaults.removeObject(forKey: "currentUserData")
                // defaults.set(nil, forKey: "currentUserData")
            }
            
            // save data
            defaults.synchronize()
            
        }
    }
}
