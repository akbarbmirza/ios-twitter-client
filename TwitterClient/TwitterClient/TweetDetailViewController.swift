//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Akbar Mirza on 3/4/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class TweetDetailViewController: UITableViewController {
    
    // =========================================================================
    // Outlets
    // =========================================================================
    
    // Retweet Information
    @IBOutlet weak var retweetIconImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    // User Information
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userhandleLabel: UILabel!
    
    // Tweet Information
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // Tweet Buttons
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    // AutoLayout Constraints
    @IBOutlet weak var retweetIconToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesLabelToLeftConstraint: NSLayoutConstraint!
    
    // =========================================================================
    // Properties
    // =========================================================================
    var tweet: Tweet! {
        // update these fields anytime the tweet is changed
        didSet {
            // if the view exists
            if self.view != nil {
                loadViews()
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let myFormat = DateFormatter()
        myFormat.setLocalizedDateFormatFromTemplate("MM/dd/YY HH:mm")
        
        return myFormat
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // give the tableView an estimate before it figure out rowHeight
        tableView.estimatedRowHeight = 120
        // tell rowHeight to use AutoLayout parameres
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        // TODO: add actions for reply, favorite, retweet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpIcons() {
        // handle favorites button and counts based on if tweet has been favorited or not
        if tweet.isFavorited! {
            favoriteButton.imageView?.image = UIImage(named: "favor-icon-red")
        } else {
            favoriteButton.imageView?.image = UIImage(named: "favor-icon")
        }
        
        // handle retweet button and counts based on if tweet has been favorited or not
        if tweet.isRetweeted! {
            retweetButton.imageView?.image = UIImage(named: "retweet-icon-green")
            
        } else {
            retweetButton.imageView?.image = UIImage(named: "retweet-icon")
        }
    }
    
    func loadViews() {
        if let myTweet = tweet {
            
            // print user's name
            self.usernameLabel.text = "\(myTweet.name!)"
            
            // print user's handle
            userhandleLabel.text = "@\(myTweet.ownerHandle!)"
            
            // print avatar image
            if let imageURL = myTweet.ownerAvatarURL {
                avatarImageView.setImageWith(imageURL)
            }
            
            // print tweet's contents
            tweetLabel.text = myTweet.text!
            
            // print the timestamp
            timestampLabel.text = dateFormatter.string(from: tweet.timestamp!)
            
            if myTweet.retweet_count == 0 {
                retweetCountLabel.isHidden = true
                retweetLabel.isHidden = true
            } else {
                // show retweetCount and labels
                retweetCountLabel.isHidden = false
                retweetLabel.isHidden = false
                // print retweetcounts
                retweetCountLabel.text = myTweet.format(count: myTweet.retweet_count)
            }
            
            if myTweet.favorites_count == 0 {
                // TODO: Adjust Favorite Counts
                favoritesLabelToLeftConstraint.isActive = false
                favoriteCountLabel.isHidden = true
                favoritesLabel.isHidden = true
            } else {
                // show retweetCount and labels
                favoritesLabelToLeftConstraint.isActive = true
                favoriteCountLabel.isHidden = false
                favoritesLabel.isHidden = false
                
                // print favoritesCount
                // set the favoritesCount
                if myTweet.isFavorited! && myTweet.favorites_count == 0 {
                    favoriteCountLabel.text = myTweet.format(count: myTweet.favorites_count + 1)
                } else {
                    favoriteCountLabel.text = myTweet.format(count: myTweet.favorites_count)
                }
            }
            
            if myTweet.isRetweetStatus {
                retweetIconImageView.isHidden = false
                retweetedByLabel.isHidden = false
                retweetedByLabel.text = "Retweeted by \(myTweet.retweetedBy!)"
                retweetIconToTopConstraint.priority = 999
            } else {
                retweetedByLabel.isHidden = true
                retweetIconImageView.isHidden = true
                retweetIconToTopConstraint.priority = 1
            }
            
            // set the icons
            // handle favorites button and counts based on if tweet has been favorited or not
            setUpIcons()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
