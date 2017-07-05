//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user.name
            screenNameLabel.text = tweet.user.screenName
            dateLabel.text = tweet.createdAtString
            tweetLabel.text = tweet.text
            retweetLabel.text = String(describing: tweet.retweetCount)
            favoriteLabel.text = String(describing: tweet.favoriteCount!)
            if tweet.favorited != nil && tweet.favorited! {
                favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
            }
            if tweet.retweeted {
                retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
            }
            profileImageView.af_setImage(withURL: tweet.profileUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
