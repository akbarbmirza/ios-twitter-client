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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        // pass our tweet into our cell so that we can use it
        cell.tweet = tweet
        
        // print user's name
        cell.userNameLabel.text = tweet.name!
        // print user's handle
        cell.userScreenNameLabel.text = "@\(tweet.ownerHandle!)"
        // print avatar image
        if let imageURL = tweet.ownerAvatarURL {
            cell.avatarImageView.setImageWith(imageURL)
        }
        // print tweet's contents
        cell.tweetDescriptionLabel.text = tweet.text!
        // print the timestamp
        cell.timeStampLabel.text = tweet.format(timestamp: tweet.timestamp)
        // print retweetcounts
        cell.retweetCountsLabel.text = tweet.format(count: tweet.retweet_count)
        
        // handle favorites button and counts based on if tweet has been favorited or not
        if (tweet.isFavorited!) {
            cell.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
            cell.favoritesLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            cell.favoritesLabel.text = tweet.format(count: tweet.favorites_count + 1)
        } else {
            cell.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon")
            cell.favoritesLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.favoritesLabel.text = tweet.format(count: tweet.favorites_count)
        }
        
        // handle retweet button and counts based on if tweet has been favorited or not
        if (tweet.isRetweeted!) {
            cell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
            cell.retweetCountsLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

        } else {
            cell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
            cell.retweetCountsLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
    }
    
}
