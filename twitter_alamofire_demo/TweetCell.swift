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
            updateCell()
        }
    }
    
    func updateCell() {
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName!)"
        dateLabel.text = tweet.createdAtString
        tweetLabel.text = tweet.text
        retweetLabel.text = String(describing: tweet.retweetCount)
        favoriteLabel.text = String(describing: tweet.favoriteCount)
        profileImageView.af_setImage(withURL: tweet.profileUrl!)
        retweetButton.isSelected = tweet.retweeted
        favoriteButton.isSelected = tweet.favorited
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .selected)
        favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        // Set state
        if !tweet.favorited {
            tweet.favorited = true
            tweet.favoriteCount += 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        // Update UI
        updateCell()
    }
    
    @IBAction func onTapRetweet(_ sender: Any) {
        // Set state
        if !tweet.retweeted {
            tweet.retweeted = true
            tweet.retweetCount += 1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        // Update UI
        updateCell()
    }
}
