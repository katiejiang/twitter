//
//  TweetDetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Katie Jiang on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .selected)
        favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .selected)
        updateInfo()
    }
    
    func updateInfo() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
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
        updateInfo()

    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
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
        updateInfo()
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
