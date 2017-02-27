//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 2/19/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    // func profileTapped(tweet: Tweet?)
    func retweetTapped(tweet: Tweet?, indexPath: IndexPath)
    func favoriteTapped(tweet: Tweet?, indexPath: IndexPath)
}

class TweetCell: UITableViewCell {
    
    // Outlets
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
    
    @IBOutlet weak var topConstraintToRetweetImage: NSLayoutConstraint!
    
    var tableView: UITableView!
    
    var delegate: TweetCellDelegate?
    var indexPath: IndexPath?
    
    // Properties
    var tweet: Tweet! {
        // update these fields anytime the tweet is changed
        didSet {
            
            // print user's name
            userNameLabel.text = tweet.name!
            
            // print user's handle
            userScreenNameLabel.text = "@\(tweet.ownerHandle!)"
            
            // print avatar image
            if let imageURL = tweet.ownerAvatarURL {
                avatarImageView.setImageWith(imageURL)
            }
            
            // print tweet's contents
            tweetDescriptionLabel.text = tweet.text!
            
            // print the timestamp
            timeStampLabel.text = tweet.format(timestamp: tweet.timestamp!)
            
            // print retweetcounts
            retweetCountsLabel.text = tweet.format(count: tweet.retweet_count)
            
            // set the favoritesCount
            if tweet.isFavorited! && tweet.favorites_count == 0 {
                favoritesLabel.text = tweet.format(count: tweet.favorites_count + 1)
            } else {
                favoritesLabel.text = tweet.format(count: tweet.favorites_count)
            }
            
            if tweet.isRetweetStatus {
                retweetLabel.isHidden = false
                retweetedImageView.isHidden = false
                retweetLabel.text = "Retweeted by \(tweet.retweetedBy!)"
                topConstraintToRetweetImage.priority = 999
                
            } else {
                retweetLabel.isHidden = true
                retweetedImageView.isHidden = true
                topConstraintToRetweetImage.priority = 1
            }
            
            // set the icons
            // handle favorites button and counts based on if tweet has been favorited or not
            setUpIcons()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpIcons() {
        // handle favorites button and counts based on if tweet has been favorited or not
        if tweet.isFavorited! {
            favoritesLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            favoriteButton.imageView?.image = UIImage(named: "favor-icon-red")
        } else {
            favoritesLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            favoriteButton.imageView?.image = UIImage(named: "favor-icon")
        }
        
        // handle retweet button and counts based on if tweet has been favorited or not
        if tweet.isRetweeted! {
            retweetCountsLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            retweetButton.imageView?.image = UIImage(named: "retweet-icon-green")
            
        } else {
            retweetCountsLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            retweetButton.imageView?.image = UIImage(named: "retweet-icon")
        }
    }
    
    // Actions
    @IBAction func onRetweet(_ sender: Any) {
        
        delegate?.retweetTapped(tweet: self.tweet, indexPath: self.indexPath!)
        
    }
    
    @IBAction func onFavorite(_ sender: Any) {

        delegate?.favoriteTapped(tweet: self.tweet, indexPath: self.indexPath!)
        
    }
    
}
