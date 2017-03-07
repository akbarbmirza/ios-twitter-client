//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/12/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Foundation

class TweetsViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // give the tableView an estimate before it figure out rowHeight
        tableView.estimatedRowHeight = 120
        // tell rowHeight to use AutoLayout parameres
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getTimeline()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        TwitterClient.sharedInstance?.logout()
    }
    
    func getTimeline() {
        TwitterClient.sharedInstance!.homeTimeline(success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            
            // NOTE: Debug Code
            // for tweet in tweets {
            //    print(tweet.text!)
            // }
            
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // TODO: Get the right view controller
        
        if segue.identifier == "tweetDetails" {
            
            // create a variable for our detail view controller
            let detailVC = segue.destination as! TweetDetailViewController
            
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let tweet = self.tweets[indexPath.row]
                detailVC.tweet = tweet
            }
            
            
        }
        
        
        print("prepare for segue call")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        // set our tableview
        cell.tableView = self.tableView
        
        // pass our tweet into our cell so that we can use it
        cell.tweet = tweet
        
        // set our cell delegate
        cell.delegate = self
        
        // set our indexPath
        cell.indexPath = indexPath
        
        // set up icons
        cell.setUpIcons()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
    }
    
    
}

extension TweetsViewController: TweetCellDelegate {
    
    func favoriteTapped(tweet: Tweet?, indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweetIndex = self.tweets.index(of: tweet!)
        
        if (tweet?.isFavorited)! {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id)!, success: { (tweet: Tweet) in
                self.tweets[tweetIndex!] = tweet
                cell.tweet = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(id: (tweet?.id)!, success: { (tweet: Tweet) in
                self.tweets[tweetIndex!] = tweet
                cell.tweet = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
    }
    
    func retweetTapped(tweet: Tweet?, indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TweetCell
        let tweetIndex = self.tweets.index(of: tweet!)
        
        if (tweet?.isRetweeted)! {
            TwitterClient.sharedInstance?.unretweet(tweet: tweet!, success: { (tweet: Tweet) in
                self.tweets[tweetIndex!] = tweet
                cell.tweet = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { (tweet: Tweet) in
                
                self.tweets[tweetIndex!] = tweet
                cell.tweet = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
    }
    
}
