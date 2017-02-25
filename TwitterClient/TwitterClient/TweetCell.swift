//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/19/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var retweetedImageView: UIImageView!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userScreenNameLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    
    @IBOutlet weak var retweetCountsLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 5
        
        retweetLabel.removeFromSuperview()
        retweetedImageView.removeFromSuperview()
//        retweetLabel.isHidden = true
//        retweetedImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        
        if (tweet.isRetweeted!) {
            
            TwitterClient.sharedInstance?.unretweet(id: tweet.id!, success: { (tweet: Tweet) in
                
                // set the tweet cell to the response
                // self.tweet = tweet
                self.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
                self.retweetCountsLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                self.retweetCountsLabel.text = tweet.format(count: tweet.retweet_count)
                
            }, failure: { (error: Error) in
                
                // code failed
                print("ERROR: \(error.localizedDescription)")
                
            })
            
        } else {
            
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (tweet: Tweet) in
                
                // set the tweet cell to the response
                // self.tweet = tweet
                
                self.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
                self.retweetCountsLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                self.retweetCountsLabel.text = tweet.format(count: tweet.retweet_count)
                
            }, failure: { (error: Error) in
                
                // code failed
                print("ERROR: \(error.localizedDescription)")
                
            })
        }
        
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        
        if (tweet.isFavorited!) {
            
            TwitterClient.sharedInstance?.unfavorite(id: tweet.id!, success: { (tweet: Tweet) in
                
                // set the tweet cell to the response
                // self.tweet = tweet
                
                self.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon")
                self.favoritesLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                self.favoritesLabel.text = tweet.format(count: tweet.favorites_count)
                
            }, failure: { (error: Error) in
                
                // code failed
                print("ERROR: \(error.localizedDescription)")
                
            })
            
        } else {
            
            TwitterClient.sharedInstance?.favorite(id: tweet.id!, success: { (tweet: Tweet) in
                
                // set the tweet cell to the response
                // self.tweet = tweet
                
                self.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
                self.favoritesLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                self.favoritesLabel.text = tweet.format(count: tweet.favorites_count)
                
            }, failure: { (error: Error) in
                
                // code failed
                print("ERROR: \(error.localizedDescription)")
                
            })
        }
        
    }
    
}
