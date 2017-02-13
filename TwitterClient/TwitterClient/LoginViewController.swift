//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/8/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        // OAUTH1 Client
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "cFTquYlFwkx3cKGF6bfThVER1", consumerSecret: "WROzIiq1HTPJY1EhyAZWfDqrZO1Sp9Kbu5FJB553PhxP4M6Vhl")
        
        twitterClient?.deauthorize()
        
        // Get a Request Token
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            print("I got a token")
            
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
