//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/12/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "cFTquYlFwkx3cKGF6bfThVER1", consumerSecret: "WROzIiq1HTPJY1EhyAZWfDqrZO1Sp9Kbu5FJB553PhxP4M6Vhl")
    
    // code we want to run on success
    var loginSuccess: ((Void) -> Void)?
    // code we want to run on failure
    var loginFailure: ((Error?) -> Void)?
    
    func login(success: @escaping (Void) -> Void, failure: @escaping (Error?) -> Void) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        // Get a Request Token
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            // NOTE: Debug Code
            // print("I got a token")
            
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) -> (Void) in
                
                // assign user to our currentUser property
                // will call our setter for our computed property and save it
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: Error) -> (Void) in
                
                self.loginFailure?(error)
                
            })
            
        }, failure: { (error: Error?) in
            
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error)
            
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDicts = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDicts)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
            
        })
        
    }
    
    func currentAccount(success: @escaping (User) -> (Void), failure: @escaping (Error) -> (Void)) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDict = response as! NSDictionary
            let user = User(dictionary: userDict)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
            
        })
        
    }
    
    func favorite(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func unfavorite(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func retweet(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/statuses/retweet/:\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func unretweet(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/statuses/retweet/:\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
}
